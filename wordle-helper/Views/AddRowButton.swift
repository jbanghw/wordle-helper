//
//  AddRowButton.swift
//  wordle-helper
//
//  Created by James Bang on 2023-10-27.
//

import SwiftUI

struct AddRowButton: View {
    
    @Bindable var viewModel: WordleViewModel
    
    var body: some View {
        Button {
            viewModel.isAddingRow = true
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 50))
                .foregroundStyle(.green)
        }
        .alert("Add Row", isPresented: $viewModel.isAddingRow, actions: {
            TextField("5-Letter Word", text: $viewModel.newWord)
                .autocapitalization(.none)
                .autocorrectionDisabled()
            
            Button("Add", action: {
                if viewModel.newWord.count != 5 || !(viewModel.newWord.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil) {
                    print("Add Word Failed!")
                } else {
                    print("Add Word Successful!")
                    viewModel.board.rows.append(WordleRow(viewModel.newWord.lowercased()))
                    viewModel.newWord = ""
                }
            })
            
            Button("Cancel", role: .cancel, action: {})
            
        }, message: {
            Text("Enter a 5-Letter word.")
        })
        .frame(maxWidth: .infinity)
    }
    
}
