//
//  BuddyViewModel.swift
//  lets-talk
//
//  Created by Stefan de Gier on 08/06/2023.
//

import Foundation

class BuddyViewModel {
    
    let buddyRepository = BuddyRepository()

    // MARK: - Properties
    public var buddy: Buddy?
    
    // MARK: - Computed Properties
    
    public var introductionMessage: String {
        return "My name is \(nameText), \(languageText) \(personalityText)"
    }
    
    public var nameText: String {
        if let name = self.buddy?.name {
            return "\(name)"
        } else {
            return "[Name]"
        }
    }
    
    private var languageText: String {
        if let language = self.buddy?.language {
            return "an \(language.rawValue.capitalizedSentence) speaking buddy."
        } else {
            return "an [Language] speaking buddy"
        }
    }
    
    private var personalityText: String {
        if let personality = self.buddy?.personality {
            if let personalityOptional = self.buddy?.personalityOptional, personalityOptional != PersonalityType.none {
                return "My personality is \(personality.rawValue) and \(personalityOptional.rawValue)."
            } else {
                return "My personality is \(personality.rawValue)."
            }
        } else {
            return "My personality is [personality]."
        }
    }

    public func validateFields() -> [String: String] {
        var errorMessages: [String: String] = [:]
        if let name = self.buddy?.name, name.isEmpty {
            errorMessages["name"] = "Name field is required"
        }
        
        if let language = self.buddy?.language.rawValue, language.isEmpty {
            errorMessages["language"] = "Language field is required"
        }
        
        if let personality = self.buddy?.personality.rawValue, personality.isEmpty {
            errorMessages["personality"] = "Personality field is required"
        }
        
        return errorMessages
    }
    
    init() {
        getBuddy()
    }
    
    public func getBuddy() -> Void {
        let result = self.buddyRepository.getBuddy()
        switch result {
        case .success(let buddy):
            self.buddy = buddy
        case .failure(let error):
            self.buddy = Buddy(name: "", language: .none, personality: .none, personalityOptional: .none)
            print("Unable to get buddy \(error)")
        }
    }
    
    public func saveBuddy() {
        if let buddy = self.buddy {
            let result = self.buddyRepository.updateBuddy(buddy: buddy)
            switch result {
            case .success(let buddy):
                // hier evenuteel returnen dat het succesvol is opgeslagen
                print(buddy)
            case .failure(let error):
                //hier eventueel returnen dat het opslaan is mislukt
                print("Unable to update buddy \(error)")
            }
        } else {
            // self.buddy is nil
        }
    }
    
}
