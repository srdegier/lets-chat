//
//  BuddyModel.swift
//  lets-talk
//
//  Created by Stefan de Gier on 11/06/2023.
//

import Foundation

enum LanguageType: String {
    case none = ""
    case dutch = "dutch"
    case english = "english"
    case german = "german"
    case french = "french"
    
    static let allValues: [LanguageType] = [.none, .dutch, .english, .german, .french]
}

enum PersonalityType: String {
    case none = ""
    case friendly = "friendly"
    case empathetic = "empathetic"
    case funny = "funny"
    case direct = "direct"
    case brave = "brave"
    case calmy = "calmy"
    case supportive = "supportive"
    
    static let allValues: [PersonalityType] = [.none, .friendly, .empathetic, .funny, .direct, .brave, .calmy, .supportive]
}

struct Buddy {
    var name: String
    var language: LanguageType
    var personality: PersonalityType
    var personalityOptional: PersonalityType
    
    init(name: String, language: LanguageType, personality: PersonalityType, personalityOptional: PersonalityType) {
        self.name = name
        self.language = language
        self.personality = personality
        self.personalityOptional = personalityOptional
    }

}
