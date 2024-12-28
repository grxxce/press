//
//  NoteEditorView.swift
//  PressTwo
//
//  Created by Grace Li on 12/27/24.
//

import SwiftUI

struct NoteEditorView: View {
    let note: Note
    let onSave: (Note) -> Void
    
    @State private var content: String
    @FocusState private var isFocused: Bool
    
    init(note: Note, onSave: @escaping (Note) -> Void) {
        self.note = note
        self.onSave = onSave
        _content = State(initialValue: note.content)
    }
    
    var body: some View {
        TextEditor(text: $content)
            .font(.body)
            .focused($isFocused)
            .onChange(of: content) { _, newValue in
                        var updatedNote = note
                        updatedNote.updateContent(newValue)
                        onSave(updatedNote)
                    }
            .onChange(of: note) { _, newNote in
                content = newNote.content
                
            }
            .onAppear {
                isFocused = note.content.isEmpty &&
               note.creationDate.timeIntervalSinceNow > -1
            }
            .scrollContentBackground(.hidden) 
            .background(Color(red:254/255, green:234/255, blue:218/255))
    }
}
