//
//  Solver.swift
//  wordle-helper
//
//  Created by James Bang on 2023-10-18.
//

import Foundation

class Solver {
    let filename: String = "words"
    var words: [String] = []
    var letters: [String] = []
    let maxLetterCount: [String: Int]
    
    init(firstLetter: String, secondLetter: String, thirdLetter: String, fourthLetter: String, fifthLetter: String, mustInclude: String, maxLetterCount: [String: Int]) {
        self.letters.append(firstLetter)
        self.letters.append(secondLetter)
        self.letters.append(thirdLetter)
        self.letters.append(fourthLetter)
        self.letters.append(fifthLetter)
        self.letters.append(mustInclude)
        self.maxLetterCount = maxLetterCount
    }
    
    func solve() {
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: "txt") else{
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            let contents = try String(contentsOf: file, encoding: String.Encoding.utf8)
            let lines = contents.split(separator:"\n")
            for line in lines {
                let word = String(line)
                var possible: Bool = true
                for i in 0...4 {
                    let wordIndex = word.index(word.startIndex, offsetBy: i)
                    if !self.letters[i].contains(word[wordIndex]) {
                        possible = false
                        break
                    }
                }
                if possible {
                    for char in self.letters[5] {
                        if !word.contains(char) {
                            possible = false
                            break
                        }
                    }
                }
                if possible {
                    let currWordLetters = word.map {String($0)}
                    var currWordCountedLetters = [String: Int]()
                    currWordLetters.forEach {currWordCountedLetters[$0, default: 0] += 1}
                    for (l, lCount) in currWordCountedLetters {
                        if maxLetterCount[l] ?? 5 < lCount {
                            possible = false
                            break
                        }
                    }
                }
                if possible {
                    self.words.append(word)
                }
            }
        } catch {
            print("Could not solve!")
        }
    }
    
}
