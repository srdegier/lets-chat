//
//  ChatRepository.swift
//  lets-talk
//
//  Created by Stefan de Gier on 21/05/2023.
//

import Foundation
import SQLite

class MessageRepository {
    
    private let sqliteDatabaseManager = SQLiteDatabaseManager.shared
    private var db: Connection
    
    let messages = Table("messages")
    let id = Expression<Int64>("id")
    let text = Expression<String>("text")
    let type = Expression<String>("type")
    let solution = Expression<Bool>("solution")
    
    // MARK: Properties
    
    private var lastMessageID: Int64?
    
    init() {
        guard let db = sqliteDatabaseManager.db else {
            fatalError("No database connection found")
        }
        self.db = db
        self.createTable()
    }
    
    internal func createTable() -> Void {
        do {
            try self.db.run(messages.create { table in
                table.column(id, primaryKey: true)
                table.column(text)
                table.column(type)
                table.column(solution)
            })
        } catch {
            print("!@Error creating table: \(error)")
        }
    }
    
    public func addMessage(text: String, type: String, solution: Bool) {
        do {
            try self.db.run(messages.insert(self.text <- text, self.type <- type, self.solution <- solution))
        } catch {
            print("!@insertion failed: \(error)")
        }
    }
    
    public func getMessages() throws -> [Message] {
        var fetchedMessages: [Message] = []
        var query = messages.select(id, text, type).order(id.desc).limit(20)
        if let lastID = self.lastMessageID {
            query = query.filter(id < lastID)
        }
        
        for row in try db.prepare(query) {
            let messageID = row[id]
            let messageText = row[text]
            let messageTypeRawValue = row[type]
            let messageType = MessageType(rawValue: messageTypeRawValue) ?? .receiver
            
            let message = Message(message: messageText, type: messageType)
            fetchedMessages.append(message)
            
            self.lastMessageID = messageID

        }
        
        return fetchedMessages.reversed()
    }

}
