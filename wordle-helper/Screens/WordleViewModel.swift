//
//  WordleViewModel.swift
//  wordle-helper
//
//  Created by James Bang on 2023-10-27.
//

import SwiftUI

@Observable
final class WordleViewModel {
    
    var board = WordleBoard()
    var solution: [String]?
    var isAddingRow = false
    var newWord = ""
    var isShowingSolution = false
    
    func solve() {
        var letters: [String] = [
            "abcdefghijklmnopqrstuvwxyz",
            "abcdefghijklmnopqrstuvwxyz",
            "abcdefghijklmnopqrstuvwxyz",
            "abcdefghijklmnopqrstuvwxyz",
            "abcdefghijklmnopqrstuvwxyz",
            ""
        ]
        
        for row in self.board.rows {
            for i in 0..<5 {
                let currLetter = String(row.word[row.word.index(row.word.startIndex, offsetBy: i)])
                if row.colors[i] == .gray {
                    for j in 0..<5 {
                        letters[j] = letters[j].replacingOccurrences(of: currLetter, with: "")
                    }
                } else if row.colors[i] == .yellow {
                    letters[i] = letters[i].replacingOccurrences(of: currLetter, with: "")
                    letters[5] += currLetter
                } else {
                    letters[i] = currLetter
                    letters[5] += currLetter
                }
            }
        }
        
        let solver = Solver(firstLetter: letters[0], secondLetter: letters[1], thirdLetter: letters[2], fourthLetter: letters[3], fifthLetter: letters[4], mustInclude: letters[5])
        solver.solve()
        
        self.solution = solver.words
    }
    
}
