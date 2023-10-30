//
//  SolveButton.swift
//  wordle-helper
//
//  Created by James Bang on 2023-10-27.
//

import SwiftUI

struct SolveButton: View {
    
    @Bindable var viewModel: WordleViewModel
    
    var body: some View {
        Button("Solve") {
            viewModel.solve()
            viewModel.isShowingSolution = true
        }
        .padding(.vertical)
        .font(.title)
        .foregroundStyle(.green)
        .bold()
        .sheet(isPresented: $viewModel.isShowingSolution) {
            viewModel.solution = nil
        } content: {
            if let soln = viewModel.solution {
                WordleSolutionView(solutions: soln)
            }
        }
    }
}
