//
//  WordleBoard.swift
//  wordle-helper
//
//  Created by James Bang on 2023-10-27.
//

import SwiftUI

class WordleBoard: ObservableObject {
    
    @Published var rows = [WordleRow]()
    
    init() {
        self.rows = []
    }
}
