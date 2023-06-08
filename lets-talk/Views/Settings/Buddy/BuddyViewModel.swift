//
//  BuddyViewModel.swift
//  lets-talk
//
//  Created by Stefan de Gier on 08/06/2023.
//

import Foundation

class BuddyViewModel {
    
    // MARK: - Properties
    
    public var name: String?
    public var language: String?
    public var personality: String?
    public var personalityOptional: String?
    public var behaviour: String?
    public var behaviourOptional: String?
    
    // MARK: - Computed Properties
    
    public var introductionMessage: String {
        return "My name is \(nameText), \(languageText) \(personalityText) \(behaviourText)"
    }
    
    public var nameText: String {
        if let name = self.name {
            return "\(name)"
        } else {
            return "[Name]"
        }
    }
    
    private var languageText: String {
        if let language = self.language {
            return "an \(language) speaking buddy."
        } else {
            return "an [Language] speaking buddy"
        }
    }
    
    private var personalityText: String {
        if let personality = self.personality {
            if let personalityOptional = self.personalityOptional {
                return "My personality is \(personality.lowercased()) and \(personalityOptional.lowercased())."
            } else {
                return "My personality is \(personality.lowercased())."
            }
        } else {
            return "My personality is [personality]."
        }
    }

    private var behaviourText: String {
        if let behaviour = self.behaviour {
            if let behaviourOptional = self.behaviourOptional {
                return "Also I behave by \(behaviour.lowercased()) and \(behaviourOptional.lowercased())."
            } else {
                return "Also I behave by \(behaviour.lowercased())."
            }
        } else {
            return "Also I behave by [behaviour]."
        }
    }
    
    // MARK: - Data Source
    
    let languageTypes: [String] = [
        "Dutch",
        "English",
        "German",
        "French",
    ]
    let personalityTypes: [String] = [
        "Friendly",
        "Empathetic",
        "Funny",
        "Direct",
        "brave",
        "Calmy",
        "Supportive",
    ]
    
    let behaviourTypes: [String] = [
        "Asking questions",
        "Listening",
        "Businesslike",
        "Giving suggestions",
        "Cheering on",
        "Brave",
        "Calmy",
        "Supportive",
    ]
    
    public func validateFields() -> [String: String] {
        var errorMessages: [String: String] = [:]
        if let name = self.name, name.isEmpty {
            errorMessages["name"] = "Name field is required"
        }
        
        if let language = self.language, language.isEmpty {
            errorMessages["language"] = "Language field is required"
        }
        
        if let personality = self.personality, personality.isEmpty {
            errorMessages["personality"] = "Personality field is required"
        }
        
        if let behaviour = self.behaviour, behaviour.isEmpty {
            errorMessages["behaviour"] = "Behaviour field is required"
        }
        
        return errorMessages
    }
    
    public func updateBuddy() {
        print("Opslaan van de gegevens")
    }
    
}
