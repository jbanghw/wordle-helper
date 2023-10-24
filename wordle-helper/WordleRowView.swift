//
//  WordleRowColorView.swift
//  wordle-helper
//
//  Created by James Bang on 2023-10-22.
//

import SwiftUI

struct WordleRowView: View {
    @ObservedObject var wordleRow: WordleRow
    
    var body: some View {
        
        HStack {
            LetterBox(wr: wordleRow, idx: 0)
            LetterBox(wr: wordleRow, idx: 1)
            LetterBox(wr: wordleRow, idx: 2)
            LetterBox(wr: wordleRow, idx: 3)
            LetterBox(wr: wordleRow, idx: 4)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .aspectRatio(contentMode: .fit)
    }
}

#Preview {
    WordleRowView(wordleRow: WordleRow("hello"))
}

struct LetterBox: View {
    @ObservedObject var wr: WordleRow
    
    let idx: Int
    
    var letter: String {
        String(wr.word[wr.word.index(wr.word.startIndex, offsetBy: idx)])
    }
    
    var body: some View {
        Button(letter.uppercased()) {
            switch wr.colors[idx] {
            case .gray:
                wr.colors[idx] = .yellow
            case .yellow:
                wr.colors[idx] = .green
            default:
                wr.colors[idx] = .gray
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.white)
        .background(wr.colors[idx])
        .buttonStyle(.plain)
    }
}
