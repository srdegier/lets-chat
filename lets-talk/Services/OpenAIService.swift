//
//  OpenAIService.swift
//  lets-talk
//
//  Created by Stefan de Gier on 25/05/2023.
//

import Foundation
import OpenAISwift

class OpenAIService {
    
    // set apikey in the config file
    let openAI = OpenAISwift(authToken: Config.apiKey())
    
    public func fetchRespond(payload:[ChatMessage]) async -> Result<OpenAI<MessageResult>, Error> {
        do {
            let chat: [ChatMessage] = payload
                        
            let result = try await openAI.sendChat(
                with: chat,
                model: .chat(.chatgpt),
                temperature: 0.5,
                topProbabilityMass: 1.0,
                maxTokens: 100,
                presencePenalty: 0.0,
                frequencyPenalty: 0.5
            )
            
            return .success(result)
        } catch  {
            return .failure(error)
        }
    }
}
