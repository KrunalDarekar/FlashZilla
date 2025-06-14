//
//  Card.swift
//  Flashzilla
//
//  Created by krunal darekar on 15/04/25.
//

import Foundation
import SwiftData

@Model
class Card {
    var id = UUID()
    var prompt: String
    var answer: String
    
    init(id: UUID = UUID(), prompt: String, answer: String) {
        self.id = id
        self.prompt = prompt
        self.answer = answer
    }
    // static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
