//
//  EditCarGroupView.swift
//  Flashzilla
//
//  Created by Krunal  on 02/07/25.
//

import SwiftUI

struct EditCardGroupView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String
    @State private var cards: [Card]
    @State private var showingEditCards = false
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    private let editingGroup: CardGroup?
    
    init(cardGroup: CardGroup? = nil) {
        editingGroup = cardGroup
        _name = State(initialValue: cardGroup?.name ?? "")
        _cards = State(initialValue: cardGroup?.cards ?? [])
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Group Name", text: $name)
                }
                
                List {
                    Section("Add new card") {
                        TextField("Prompt", text: $newPrompt)
                        TextField("Answer", text: $newAnswer)
                        Button("Add Card", action: addCard)
                    }

                    Section("Cards") {
                        ForEach(cards) { card in
                            VStack(alignment: .leading) {
                                Text(card.prompt)
                                    .font(.headline)
                                Text(card.answer)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .onDelete(perform: removeCards)
                    }
                }
                
            }
            .navigationTitle(name.isEmpty ? "New Group" : "Edit Group")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func save() {
        if let group = editingGroup {
            // Update existing group
            group.name = name
            group.cards = cards
        } else {
            // Create new group
            let group = CardGroup(name: name, cards: cards)
            modelContext.insert(group)
        }
    }
    
    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }

        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        cards.append(card)
        newPrompt = ""
        newAnswer = ""
    }

    func removeCards(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
    }
}
