//
//  ContentView.swift
//  wordle-helper
//
//  Created by James Bang on 2023-10-18.
//

import SwiftUI

struct WordleView: View {
    
    @StateObject var viewModel = WordleViewModel()
    
    var body: some View {
        NavigationView {
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
                    SolveButton(viewModel: viewModel)
                    Spacer()
                }
            }
            .navigationTitle("Wordle Helper")
        }
    }
}

#Preview {
    WordleView().preferredColorScheme(.dark)
}


