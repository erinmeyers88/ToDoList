//
//  ToDo.swift
//  ToDoList
//
//  Created by Erin Vincent on 7/25/19.
//  Copyright © 2019 Erin Vincent. All rights reserved.
//

import Foundation

struct ToDo : Codable, Equatable {
    
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    static func loadToDos() -> [ToDo]? {
        guard let codedToDos = try? Data(contentsOf: ArchiveURL) else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<ToDo>.self, from: codedToDos)
    }
    
    static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("todos").appendingPathExtension("plist")
    
    static func saveToDos(_ todos: [ToDo]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(todos)
        try? codedToDos?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.title == rhs.title
    }
    
}
