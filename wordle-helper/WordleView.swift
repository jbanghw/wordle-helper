//
//  ContentView.swift
//  wordle-helper
//
//  Created by James Bang on 2023-10-18.
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

class WordleBoard: ObservableObject {
    
    @Published var rows = [WordleRow]()
    
    init() {
        self.rows = []
    }
}

struct WordleView: View {
    
    @State var board = WordleBoard()
    @State var solution: [String]?
    @State private var addRow = false
    @State private var newWord = ""
    @State private var isShowingSolution = false
    
    func solve() -> [String] {
        
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
        
        return solver.words
        
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(board.rows) { wordleRow in
                        WordleRowView(wordleRow: wordleRow)
                    }
                    .onDelete { board.rows.remove(atOffsets: $0) }
                    .listRowBackground(Color.clear)
                    
                    if board.rows.count < 5 {
                        Button {
                            addRow.toggle()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(.green)
                        }
                        .alert("Add Row", isPresented: $addRow, actions: {
                            TextField("5-Letter Word", text: $newWord)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                            
                            Button("Add", action: {
                                if newWord.count != 5 || !(newWord.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil) {
                                    print("Add Word Failed!")
                                } else {
                                    print("Add Word Successful!")
                                    board.rows.append(WordleRow(newWord.lowercased()))
                                    newWord = ""
                                }
                            })
                            
                            Button("Cancel", role: .cancel, action: {})
                            
                        }, message: {
                            Text("Enter a 5-Letter word.")
                        })
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.clear)
                    }
                }
                Button("Solve") {
                    solution = self.solve()
                    isShowingSolution.toggle()
                }
                .padding(.vertical)
                .font(.title)
                .foregroundStyle(.green)
                .bold()
                .sheet(isPresented: $isShowingSolution) {
                    solution = nil
                } content: { [solution] in
                    if let soln = solution {
                        WordleSolutionView(solutions: soln)
                    }
                }
            }
            .navigationTitle("Wordle Helper")
        }
    }
}

#Preview {
    WordleView()
}
