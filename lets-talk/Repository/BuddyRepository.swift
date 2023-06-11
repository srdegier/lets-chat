//
//  BuddyRepository.swift
//  lets-talk
//
//  Created by Stefan de Gier on 11/06/2023.
//

import Foundation
import SQLite

enum SQLiteResultData<T> {
    case success(value: T)
    case failure(error: Error)
}

class BuddyRepository {
    
    private let sqliteDatabaseManager = SQLiteDatabaseManager.shared
    private var db: Connection
    
    let buddy = Table("buddy")
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    let language = Expression<String>("language")
    let personality = Expression<String>("personality")
    let personalityOptional = Expression<String>("personalityOptional")
    
    init() {
        guard let db = sqliteDatabaseManager.db else {
            fatalError("No database connection found")
        }
        self.db = db
        self.createTableIfNeeded()
    }
    
    private func createTableIfNeeded() {
        let tableExists = try? self.db.scalar(buddy.exists)
        if tableExists == nil {
            print("Ik bestaat nog niet :(")
            self.createTable()
            self.insertInitialData()
        }
        //self.dropTable()
    }
    
    internal func createTable() -> Void {
        do {
            try self.db.run(buddy.create { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(language)
                table.column(personality)
                table.column(personalityOptional)
            })
        } catch {
            print("!@Error creating table: \(error)")
        }
    }
    
    private func insertInitialData() {
        do {
            let insert = buddy.insert(name <- "Flora", language <- LanguageType.english.rawValue, personality <- PersonalityType.empathetic.rawValue, personalityOptional <- PersonalityType.friendly.rawValue)
            try self.db.run(insert)
        } catch {
            print("!@Error inserting initial data: \(error)")
        }
    }
    
    public func getBuddy() -> SQLiteResultData<Buddy> {
        do {
            let query = buddy.limit(1) // Ophalen van slechts één rij
            
            guard let result = try db.pluck(buddy) else {
                print("Buddy not found")
                return .failure(error: NSError(domain: "BuddyNotFoundError", code: 0, userInfo: nil))
            }
            
            let buddyName = result[name]
            
            guard let buddyLanguageType = LanguageType(rawValue: result[language]) else {
                return .failure(error: NSError(domain: "InvalidLanguageError", code: 0, userInfo: nil))
            }
            guard let buddyPersonalityType = PersonalityType(rawValue:  result[personality]) else {
                return .failure(error: NSError(domain: "InvalidPersonalityError", code: 0, userInfo: nil))
            }
            
            guard let buddyPersonalityOptionalType = PersonalityType(rawValue: result[personalityOptional]) else {
                return .failure(error: NSError(domain: "InvalidPersonalityOptionalError", code: 0, userInfo: nil))
            }
            
            let buddy = Buddy(name: buddyName, language: buddyLanguageType, personality: buddyPersonalityType, personalityOptional: buddyPersonalityOptionalType)
                        
            return .success(value: buddy)
            
        } catch {
            print("!@Error fetching buddy: \(error)")
            return .failure(error: error)
        }
    }
    
    public func updateBuddy(buddy: Buddy) -> SQLiteResultData<Void> {
        do {
            let update = self.buddy.update([
                name <- buddy.name,
                language <- buddy.language.rawValue,
                personality <- buddy.personality.rawValue,
                personalityOptional <- buddy.personalityOptional.rawValue
            ])
            try self.db.run(update)
            return .success(value: ())
        } catch {
            print("!@Error updating buddy: \(error)")
            return .failure(error: error)
        }
    }

    private func dropTable() {
        do {
            try self.db.run(buddy.drop(ifExists: true))
        } catch {
            print("!@Error dropping table: \(error)")
        }
    }
}
