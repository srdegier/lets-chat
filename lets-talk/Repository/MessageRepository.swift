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

}
