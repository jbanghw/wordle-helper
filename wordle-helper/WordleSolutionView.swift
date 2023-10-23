//
//  WordleSolutionView.swift
//  wordle-helper
//
//  Created by James Bang on 2023-10-23.
//

import SwiftUI

struct WordleSolutionView: View {
    
    @Binding var solutions: [String]
    
    var body: some View {
        ScrollView {
            if solutions.isEmpty {
                Text("No word matches the board!")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.red)
                    .padding(.top)
            } else {
                ForEach(solutions.indices, id: \.self) {
                    Text(solutions[$0])
                        .font(.title2)
                        .bold()
                        .padding(.vertical, 1.0)
                }
            }
        }
        .padding(.top, 50.0)
    }
}

#Preview {
    WordleSolutionView(solutions: .constant(["trope", "tempo", "netop"]))
    //    WordleSolutionView(solutions: .constant([]))
}
