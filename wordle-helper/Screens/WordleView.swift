//
//  ContentView.swift
//  wordle-helper
//
//  Created by James Bang on 2023-10-18.
//

import SwiftUI
import PhotosUI

struct WordleView: View {
    
    @State var viewModel = WordleViewModel()
    @State private var boardImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(viewModel.board.rows) { wordleRow in
                        WordleRowView(wordleRow: wordleRow)
                    }
                    .onDelete { viewModel.board.rows.remove(atOffsets: $0) }
                    .listRowBackground(Color.clear)
                    
                    if viewModel.board.rows.count < 5 {
                        AddRowButton(viewModel: viewModel)
                            .padding()
                            .listRowBackground(Color.clear)
                    }
                }
                
                HStack {
                    Spacer()
                    
                    ClearRowsButton(viewModel: viewModel)
                    
                    Spacer()
                    
                    PhotosPicker(selection: $photosPickerItem, matching: .images) {
                        Image(systemName: "camera.fill")
                            .foregroundStyle(.yellow)
                            .font(.title)
                    }
                    
                    Spacer()
                    
                    SolveButton(viewModel: viewModel)
                    
                    Spacer()
                }
                .onChange(of: photosPickerItem) { oldValue, newValue in
                    Task {
                        if let photosPickerItem,
                           let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                            if let image = UIImage(data: data) {
                                viewModel.loadImage(image: image)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Wordle Helper")
            .alert("Couldn't recognize the Wordle board.", isPresented: $viewModel.isShowingAlert) {}
        }
    }
}

#Preview {
    WordleView().preferredColorScheme(.dark)
}


