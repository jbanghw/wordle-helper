//
//  WordleViewModel.swift
//  wordle-helper
//
//  Created by James Bang on 2023-10-27.
//

import SwiftUI
import Vision

@Observable
final class WordleViewModel {
    
    var board = WordleBoard()
    var solution: [String]?
    var isAddingRow = false
    var newWord = ""
    var isShowingSolution = false
    var isShowingAlert = false
    
    func convertImageToBW(image: UIImage) -> UIImage {

//        let filter = CIFilter(name: "CIPhotoEffectMono")
        let filter = CIFilter(name: "CIPhotoEffectTonal")

        // convert UIImage to CIImage and set as input

        let ciInput = CIImage(image: image)
        filter?.setValue(ciInput, forKey: "inputImage")

        // get output CIImage, render as CGImage first to retain proper UIImage scale

        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)

        return UIImage(cgImage: cgImage!)
    }
    
    func loadImage(image: UIImage) {
        let processedImage = convertImageToBW(image: image)
        guard let cgImage = processedImage.cgImage else { return }
        
        // Create a new image-request handler.
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        
        // Create a new request to recognize text.
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        request.recognitionLevel = VNRequestTextRecognitionLevel.accurate
        request.revision = VNRecognizeTextRequestRevision2
        request.recognitionLanguages = ["en"]
        request.usesLanguageCorrection = true
        
        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
        
        print(recognizedStrings)
        
        var letters: [String] = []
        
        for string in recognizedStrings {
            for letter in string {
                letters.append(String(letter))
            }
        }
        
        // Process the recognized strings.
        if !letters.count.isMultiple(of: 5) {
            isShowingAlert = true
            return
        }
        
        board.rows.removeAll()
        
        var currWord = ""
        for letter in letters {
            if currWord.count == 5 {
                board.rows.append(WordleRow(currWord))
                currWord = ""
            }
            var rightLetter = letter
            if letter == "-" {
                rightLetter = "I"
            }
            if letter == "0" {
                rightLetter = "O"
            }
            currWord += rightLetter.lowercased()
        }
        board.rows.append(WordleRow(currWord))
    }
    
    
    func solve() {
        var letters: [String] = [
            "abcdefghijklmnopqrstuvwxyz",
            "abcdefghijklmnopqrstuvwxyz",
            "abcdefghijklmnopqrstuvwxyz",
            "abcdefghijklmnopqrstuvwxyz",
            "abcdefghijklmnopqrstuvwxyz",
            ""
        ]
        
        var maxLetterCount = [String: Int]()
        letters[0].forEach {maxLetterCount[String($0)] = 5}
        
        for row in self.board.rows {
            for i in 0..<5 {
                let currLetter = String(row.word[row.word.index(row.word.startIndex, offsetBy: i)])
                if row.colors[i] == .gray {
                    var containsCount = 0
                    
                    for j in 0..<5 {
                        if String(row.word[row.word.index(row.word.startIndex, offsetBy: j)]) == currLetter && row.colors[j] != .gray {
                            containsCount += 1
                        }
                    }
                    
                    maxLetterCount[currLetter] = containsCount
                    
                    if containsCount != 0 {
                        letters[i] = letters[i].replacingOccurrences(of: currLetter, with: "")
                    } else {
                        for j in 0..<5 {
                            letters[j] = letters[j].replacingOccurrences(of: currLetter, with: "")
                        }
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
        
        let solver = Solver(firstLetter: letters[0], secondLetter: letters[1], thirdLetter: letters[2], fourthLetter: letters[3], fifthLetter: letters[4], mustInclude: letters[5], maxLetterCount: maxLetterCount)
        solver.solve()
        
        self.solution = solver.words
    }
    
}
