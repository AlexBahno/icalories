//
//  icaloriesApp.swift
//  icalories
//
//  Created by Alexandr Bahno on 28.06.2023.
//

import SwiftUI

@main
struct icaloriesApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
