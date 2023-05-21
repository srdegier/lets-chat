//
//  SQLiteDatabaseManager.swift
//  lets-talk
//
//  Created by Stefan de Gier on 21/05/2023.
//

import Foundation
import SQLite

class SQLiteDatabaseManager {
    
    static let shared = SQLiteDatabaseManager()
    public var db: Connection?

    private init() {
        let fileManager = FileManager.default
        let documentsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let databaseURL = documentsURL.appendingPathComponent("database.sqlite")

        db = try? Connection(databaseURL.path)
    }

    deinit {
        db = nil
    }
    
    public func deleteDatabase() {
        print("!@ verwijderen")
        let fileManager = FileManager.default
        let documentsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let databaseURL = documentsURL.appendingPathComponent("database.sqlite")
        do {
            let fileURL = NSURL(fileURLWithPath: databaseURL.path)
            try fileManager.removeItem(at: fileURL as URL)
            print("!@Database Deleted!")
        } catch {
            print("!@Error \(error)")
        }
    }
}
