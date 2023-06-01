//
//  Config.swift
//  lets-talk
//
//  Created by Stefan de Gier on 29/05/2023.
//

import Foundation

enum Config {
    static func apiKey() -> String {
        guard let secretsPath = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let secrets = NSDictionary(contentsOfFile: secretsPath),
              let apiKey = secrets["APIKey"] as? String else {
            fatalError("API key not found in Secrets.plist")
        }
        return apiKey
    }
}
