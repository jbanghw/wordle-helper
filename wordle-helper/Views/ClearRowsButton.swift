//
//  ClearButton.swift
//  wordle-helper
//
//  Created by James Bang on 2023-10-27.
//

import SwiftUI

struct ClearRowsButton: View {
    
    @ObservedObject var viewModel: WordleViewModel
    
    var body: some View {
        Button("Clear") {
            viewModel.objectWillChange.send()
            viewModel.board.rows.removeAll()
        }
        .padding(.vertical)
        .font(.title)
        .foregroundStyle(.red)
        .bold()
    }
    
}
