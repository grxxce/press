//
//  PressTwoApp.swift
//  PressTwo
//
//  Created by Grace Li on 12/27/24.
//

import SwiftUI
import SwiftData

@main
struct NotesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(after: .undoRedo) {
            }
        }
    }
}
