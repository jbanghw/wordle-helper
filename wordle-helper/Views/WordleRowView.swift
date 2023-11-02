//
//  WordleRowColorView.swift
//  wordle-helper
//
//  Created by James Bang on 2023-10-22.
//

import SwiftUI

struct WordleRowView: View {
    @State var wordleRow: WordleRow
    
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
    @Bindable var wr: WordleRow
    
    let idx: Int
    
    var letter: String {
        String(wr.word[wr.word.index(wr.word.startIndex, offsetBy: idx)])
    }
    
    var body: some View {
        Button(action: {
            switch wr.colors[idx] {
            case .gray:
                wr.colors[idx] = .yellow
            case .yellow:
                wr.colors[idx] = .green
            default:
                wr.colors[idx] = .gray
            }
        }) {
            Text(letter.uppercased())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
        }
        .foregroundStyle(.white)
        .background(wr.colors[idx])
        .buttonStyle(.plain)
    }
}
