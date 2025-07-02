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
