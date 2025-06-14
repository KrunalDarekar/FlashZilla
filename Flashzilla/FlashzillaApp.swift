//
//  FlashzillaApp.swift
//  Flashzilla
//
//  Created by krunal darekar on 15/04/25.
//

import SwiftData
import SwiftUI

@main
struct FlashzillaApp: App {
    var body: some Scene {
        WindowGroup {
            CardGroupListView()
        }
        .modelContainer(for: [Card.self, CardGroup.self])
    }
}
