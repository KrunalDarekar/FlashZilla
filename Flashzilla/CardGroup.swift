import Foundation
import SwiftData

@Model
class CardGroup {
    var id = UUID()
    var name: String
    @Relationship(deleteRule: .cascade) var cards: [Card]
    
    init(id: UUID = UUID(), name: String, cards: [Card] = []) {
        self.id = id
        self.name = name
        self.cards = cards
    }
} 