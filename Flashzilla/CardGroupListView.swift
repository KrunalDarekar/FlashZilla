import SwiftUI
import SwiftData

struct CardGroupListView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Query(sort: \CardGroup.name) var cardGroups: [CardGroup]
    @State private var searchText = ""
    @State private var showingNewGroupSheet = false
    @State private var selectedGroup: CardGroup?
    
    var filteredGroups: [CardGroup] {
        if searchText.isEmpty {
            return cardGroups
        } else {
            return cardGroups.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredGroups) { group in
                    NavigationLink(destination: ContentView(cardGroup: group)) {
                        VStack(alignment: .leading) {
                            Text(group.name)
                                .font(.headline)
                            Text("\(group.cards.count) cards")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            modelContext.delete(group)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                        Button {
                            selectedGroup = group
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                }
            }
            .navigationTitle("Card Groups")
            .searchable(text: $searchText, prompt: "Search groups")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingNewGroupSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewGroupSheet) {
                EditCardGroupView()
            }
            .sheet(item: $selectedGroup) { group in
                EditCardGroupView(cardGroup: group)
            }
        }
    }
}

struct EditCardGroupView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String
    @State private var cards: [Card]
    @State private var showingEditCards = false
    
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
                
                Section {
                    Button {
                        showingEditCards = true
                    } label: {
                        HStack {
                            Text("Edit Cards")
                            Spacer()
                            Text("\(cards.count) cards")
                                .foregroundStyle(.secondary)
                        }
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
            .sheet(isPresented: $showingEditCards) {
                EditCards(cards: $cards)
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
} 