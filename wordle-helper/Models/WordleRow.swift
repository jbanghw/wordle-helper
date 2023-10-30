//
//  WordleRow.swift
//  wordle-helper
//
//  Created by James Bang on 2023-10-27.
//

import SwiftUI

@Observable
class WordleRow: Identifiable {
    let id = UUID()
    var word: String
    var colors: [Color] = [.gray, .gray, .gray, .gray, .gray]
    
    init(_ word: String) {
        self.word = word
    }
}
