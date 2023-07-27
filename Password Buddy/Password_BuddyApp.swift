//
//  Password_BuddyApp.swift
//  Password Buddy
//
//  Created by Yamin Ayon on 7/27/23.
//

import SwiftUI

@main
struct Password_BuddyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
