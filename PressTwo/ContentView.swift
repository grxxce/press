//
//  ContentView.swift
//  PressTwo
//
//  Created by Grace Li on 12/27/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var viewModel = NotesViewModel()
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView(viewModel: viewModel)
        }
        
        detail: {
            if let note = viewModel.selectedNote {
                NoteEditorView(note: note, onSave: viewModel.updateNote)
            } else {
                VStack{
                    Text("What's on your mind?")
                        .foregroundStyle(.secondary)
                    Text("⌘ + n")
                        .foregroundStyle(.secondary)
                }
                    
            }
            
        }
        
        .background(Color(red:254/255, green:234/255, blue:218/255))
        .toolbarBackground(Color(red: 255/255, green: 227/255, blue: 206/255).opacity(0.0001), for: .automatic)
        .navigationTitle("")
        .toolbar(.hidden)
    }
}

//#Preview {
//    ContentView()
//}
