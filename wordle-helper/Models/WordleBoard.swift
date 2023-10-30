//
//  WordleBoard.swift
//  wordle-helper
//
//  Created by James Bang on 2023-10-27.
//

import SwiftUI

@Observable
class WordleBoard {
    
    var rows = [WordleRow]()
    
    init() {
        self.rows = []
    }
}
