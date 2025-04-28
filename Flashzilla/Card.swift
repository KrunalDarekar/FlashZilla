//
//  Card.swift
//  Flashzilla
//
//  Created by krunal darekar on 15/04/25.
//

import Foundation

struct Card: Codable, Identifiable {
    var id = UUID()
    var prompt: String
    var answer: String

    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
