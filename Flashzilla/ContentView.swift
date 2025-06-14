//
//  ContentView.swift
//  Flashzilla
//
//  Created by krunal darekar on 15/04/25.
//

import SwiftData
import SwiftUI

extension View {
    func stacked(at position:Int, in total:Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    @Environment(\.modelContext) var modelContext
    
    @Query var allCards: [Card]
    @State private var activeCards: [Card] = []
    @State private var showingEditScreen = false
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack {
            Color("bgcolor")
                .ignoresSafeArea()
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                
                ZStack {
                    ForEach(Array(activeCards.enumerated()), id: \.element.id) { (index, card) in
                        CardView(
                            card: card,
                            addBack: {
                                withAnimation {
                                    removeCard(at: index, addBack: true)
                                }
                            },
                            removal: {
                                withAnimation {
                                    removeCard(at: index, addBack: false)
                                }
                            }
                        )
                        .stacked(at: index, in: activeCards.count)
                        .allowsHitTesting(index == activeCards.count - 1)
                        .accessibilityHidden(index < activeCards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if activeCards.isEmpty || timeRemaining == 0 {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(.capsule)
                        .padding(.top, 30)
                }
            }
            
            VStack {
                HStack {
                    Spacer()

                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                    }
                }

                Spacer()
            }
            .foregroundStyle(.white)
            .font(.largeTitle)
            .padding()
            
            if accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                                withAnimation {
                                    removeCard(at: activeCards.count - 1, addBack: true)
                                }
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .padding()
                                    .background(.black.opacity(0.7))
                                    .clipShape(.circle)
                            }
                            .accessibilityLabel("Wrong")
                            .accessibilityHint("Mark your answer as being incorrect.")

                            Spacer()

                            Button {
                                withAnimation {
                                    removeCard(at: activeCards.count - 1, addBack: false)
                                }
                            } label: {
                                Image(systemName: "checkmark.circle")
                                    .padding()
                                    .background(.black.opacity(0.7))
                                    .clipShape(.circle)
                            }
                            .accessibilityLabel("Correct")
                            .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }

        }
        .onReceive(timer) { time in
            guard isActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                if activeCards.isEmpty {
                    isActive = false
                } else {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init)
        .onAppear(perform: resetCards)
    }
    
    func removeCard(at index: Int, addBack: Bool) {
        guard index >= 0 else { return }
        let card = activeCards[index]
        activeCards.remove(at: index)
        if(addBack) {
            activeCards.insert(card, at: 0)
        }
        if activeCards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        activeCards = allCards.shuffled()
        timeRemaining = 100
        isActive = true
    }
    
    func loadData() {
        // No longer needed as we're using SwiftData
    }
}

#Preview {
    ContentView()
}
