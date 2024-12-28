//
//  NotesManager.swift
//  PressTwo
//
//  Created by Grace Li on 12/27/24.
//
//Singleton class that does not need to be re-declared
import Foundation

class NoteManager {
    static let shared = NoteManager()
    private let fileManager = FileManager.default
    private let notesDirectoryName = "notes"
    private let metadataFileName = "metadata.json"
    
    private var notesDirectory: URL {
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documents.appendingPathComponent(notesDirectoryName)
    }
    
    private var metadataPath: URL {
        return notesDirectory.appendingPathComponent(metadataFileName)
    }
    
    private init() {
        createNotesDirectoryIfNeeded()
    }
    
    private func createNotesDirectoryIfNeeded() {
        if !fileManager.fileExists(atPath: notesDirectory.path) {
            try? fileManager.createDirectory(at: notesDirectory, withIntermediateDirectories: true)
        }
    }
    
    func getNotePath(for id: UUID) -> URL {
        return notesDirectory.appendingPathComponent("\(id.uuidString).md")
    }
    
    // MARK: - Note Operations
    
    func createNote() -> Note {
        let note = Note()
        saveNote(note)
        return note
    }
    
    func saveNote(_ note: Note) {
        do {
            // Save note content
            let notePath = getNotePath(for: note.id)
            try note.content.write(to: notePath, atomically: true, encoding: .utf8)
            
            // Update metadata
            updateMetadata(for: note)
        } catch {
            print("Error saving note: \(error)")
        }
    }
    
    func loadNote(id: UUID) -> Note? {
        do {
            let notePath = getNotePath(for: id)
            let content = try String(contentsOf: notePath, encoding: .utf8)
            let metadata = getMetadata().first { $0.id == id }
            
            guard let metadata = metadata else { return nil }
            
            return Note(id: id,
                        content: content, creationDate: metadata.creationDate)
        } catch {
            print("Error loading note: \(error)")
            return nil
        }
    }
    
  
    func deleteNote(id: UUID) {
        do {
            let notePath = getNotePath(for: id)
            try fileManager.removeItem(at: notePath)
            removeMetadata(for: id)
        } catch {
            print("Error deleting note: \(error)")
        }
    }
    
    // MARK: - Metadata Operations
    
    private func getMetadata() -> [NoteMetadata] {
        do {
            let data = try Data(contentsOf: metadataPath)
            return try JSONDecoder().decode([NoteMetadata].self, from: data)
        } catch {
            return []
        }
    }
    
    private func saveMetadata(_ metadata: [NoteMetadata]) {
        do {
            let data = try JSONEncoder().encode(metadata)
            try data.write(to: metadataPath)
        } catch {
            print("Error saving metadata: \(error)")
        }
    }
    
    private func updateMetadata(for note: Note) {
        var metadata = getMetadata()
        let noteMetadata = NoteMetadata(id: note.id,
                                      title: note.title,
                                      creationDate: note.creationDate,
                                      modificationDate: note.modificationDate)
        
        if let index = metadata.firstIndex(where: { $0.id == note.id }) {
            metadata[index] = noteMetadata
        } else {
            metadata.append(noteMetadata)
        }
        
        saveMetadata(metadata)
    }
    
    private func removeMetadata(for id: UUID) {
        var metadata = getMetadata()
        metadata.removeAll { $0.id == id }
        saveMetadata(metadata)
    }
    
    // MARK: - Note Listing
    
    func getAllNotes() -> [NoteMetadata] {
        return getMetadata().sorted { $0.creationDate > $1.creationDate }
//        return getMetadata()
    }
}
