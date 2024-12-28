//
//  Note.swift
//  PressTwo
//
//  Created by Grace Li on 12/27/24.
//

import Foundation
import AppKit

struct Note: Codable, Hashable, Identifiable {
    let id: UUID
    var title: String
    var content: String
    let creationDate: Date
    var modificationDate: Date
    
    init(id: UUID = UUID(), content: String = "", creationDate: Date? = nil) {
        self.id = id
        self.title = content.components(separatedBy: .newlines).first ?? "Untitled"
        self.content = content
        self.creationDate = creationDate ?? Date()
        

        
        self.modificationDate = Date()
    }
    
    mutating func updateContent(_ newContent: String) {
        self.content = newContent
        self.title = newContent.components(separatedBy: .newlines).first ?? "Untitled"
        self.modificationDate = Date()
    }
}

struct NoteMetadata: Codable {
    let id: UUID
    var title: String
    let creationDate: Date
    var modificationDate: Date
}


