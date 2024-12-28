//
//  SidebarView.swift
//  PressTwo
//
//  Created by Grace Li on 12/27/24.
//

import SwiftUI
struct SidebarView: View {
    @ObservedObject var viewModel: NotesViewModel
    
    var body: some View {
        List(selection: $viewModel.selectedNote) {
            ForEach(viewModel.notes) { note in
                NavigationLink(value: note) {
                    VStack(alignment: .leading) {
                        Text(note.title)
                            .lineLimit(1)
                        Text(note.modificationDate, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    viewModel.deleteNote(viewModel.notes[index])
                }
            }
        }
        .background(Color(red: 255/255, green: 227/255, blue: 206/255))
        .navigationTitle("Notes")
        .toolbar {
            ToolbarItem {
                Button(action: viewModel.createNote) {
                    Label("New Note", systemImage: "square.and.pencil")
                }
                .keyboardShortcut("n", modifiers: .command)
            }
        }
        // Add a hidden button for delete
        .overlay {
            Button(action: {
                if let selectedNote = viewModel.selectedNote {
                    viewModel.deleteNote(selectedNote)
                }
            }) {
                EmptyView()
            }
            .keyboardShortcut(.delete, modifiers: [])
            .opacity(0)
        }
    }
}

//#Preview {
//    SidebarView()
//}
