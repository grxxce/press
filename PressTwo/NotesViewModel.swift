//
//  NotesViewModel.swift
//  PressTwo
//
//  Created by Grace Li on 12/27/24.
//

import Foundation
@MainActor
class NotesViewModel: ObservableObject {
    @Published private(set) var notes: [Note] = []
    @Published var selectedNote: Note?
    private let noteManager = NoteManager.shared
    private let undoManager = UndoManager()
    
    init() {
        loadNotes()
    }
    
    func loadNotes() {
        notes = noteManager.getAllNotes().map { metadata in
            noteManager.loadNote(id: metadata.id) ?? Note(id: metadata.id)
        }
    }
    
    func createNote() {
        let note = Note()
        noteManager.saveNote(note)
        loadNotes()
        selectedNote = note
    }
    
    func updateNote(_ note: Note) {
        var updatedNote = note
        noteManager.saveNote(note)
        loadNotes()
        if selectedNote?.id == note.id {
            selectedNote = updatedNote
        }
    }
    
    
    func deleteNote(_ note: Note) {
            // Store the note and its index for undo
            let index = notes.firstIndex(where: { $0.id == note.id })
            
            undoManager.registerUndo(withTarget: self) { viewModel in
                // Restore the note on undo
                if let index = index {
                    viewModel.noteManager.saveNote(note)
                    viewModel.loadNotes()
                    // Try to restore selection
                    if viewModel.selectedNote?.id == note.id {
                        viewModel.selectedNote = note
                    }
                }
            }
            
            noteManager.deleteNote(id: note.id)
            if selectedNote?.id == note.id {
                selectedNote = nil
            }
            loadNotes()
        }
}
