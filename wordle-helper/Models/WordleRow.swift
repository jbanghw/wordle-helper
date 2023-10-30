//
//  WordleRow.swift
//  wordle-helper
//
//  Created by James Bang on 2023-10-27.
//

import SwiftUI

class WordleRow: ObservableObject, Identifiable {
    let id = UUID()
    @Published var word: String
    @Published var colors: [Color] = [.gray, .gray, .gray, .gray, .gray]
    
    init(_ word: String) {
        self.word = word
    }
}
