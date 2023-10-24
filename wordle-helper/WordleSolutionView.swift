//
//  WordleSolutionView.swift
//  wordle-helper
//
//  Created by James Bang on 2023-10-23.
//

import SwiftUI

struct WordleSolutionView: View {
    
    var solutions: [String]
    
    var body: some View {
        ScrollView {
            if solutions.isEmpty {
                Text("No word matches the board!")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .bold()
                    .foregroundStyle(.red)
                    .padding(.top)
            } else if solutions.count > 25 {
                Text("Too many words matching the board, you might as well guess!")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .bold()
                    .foregroundStyle(.red)
                    .padding(.all)
            } else {
                ForEach(solutions.indices, id: \.self) {
                    Text(solutions[$0])
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .bold()
                        .padding(.vertical, 1.0)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.top, 50.0)
    }
}

#Preview {
        WordleSolutionView(solutions: ["hello", "horse"])
}
