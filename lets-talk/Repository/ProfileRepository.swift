//
//  ProfileRepository.swift
//  lets-talk
//
//  Created by Stefan de Gier on 12/06/2023.
//

import Foundation
import SQLite

class ProfileRepository {
    
    private let sqliteDatabaseManager = SQLiteDatabaseManager.shared
    private var db: Connection
    
    let profile = Table("profile")
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    let age = Expression<Int64>("age")
    
    init() {
        guard let db = sqliteDatabaseManager.db else {
            fatalError("No database connection found")
        }
        self.db = db
        self.createTableIfNeeded()
    }
    
    private func createTableIfNeeded() {
        let tableExists = try? self.db.scalar(profile.exists)
        if tableExists == nil {
            print("Ik bestaat nog niet :(")
            self.createTable()
            self.insertInitialData() // for now this will be the case
        }
        //self.dropTable()
    }
    
    internal func createTable() -> Void {
        do {
            try self.db.run(profile.create { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(age)
            })
        } catch {
            print("!@Error creating table: \(error)")
        }
    }
    
    private func insertInitialData() {
        do {
            let insert = profile.insert(name <- "Stefan", age <- 23)
            try self.db.run(insert)
        } catch {
            print("!@Error inserting initial data: \(error)")
        }
    }
    
    public func getProfile() -> SQLiteResultData<Profile> {
        do {
            guard let result = try db.pluck(profile) else {
                print("Profile not found")
                return .failure(error: NSError(domain: "ProfileNotFoundError", code: 0, userInfo: nil))
            }
            
            let profileName = result[name]
            let profileAge = result[age]
            
            let profile = Profile(name: profileName, age: profileAge)
                        
            return .success(value: profile)
            
        } catch {
            return .failure(error: error)
        }
    }
    
    public func getName() -> SQLiteResultData<String> {
        do {
            let query = profile.select(name)
            guard let row = try db.pluck(query) else {
                return .failure(error: NSError(domain: "BuddyNotFoundError", code: 0, userInfo: nil))
            }
            let name = row[name]
            return .success(value: name)
        } catch {
            return .failure(error: error)
        }
    }
    
    public func updateProfile(profile: Profile) -> SQLiteResultData<Void> {
        do {
            let update = self.profile.update([
                name <- profile.name,
                age <- profile.age,
            ])
            try self.db.run(update)
            return .success(value: ())
        } catch {
            print("!@Error updating profile: \(error)")
            return .failure(error: error)
        }
    }
    
}
