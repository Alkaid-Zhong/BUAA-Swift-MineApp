//
//  mineApp.swift
//  mine
//
//  Created by Haoxiang Zhong on 2023/11/13.
//

import SwiftUI
import SwiftData


@main
struct mineApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Records.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
        }
    }
}
