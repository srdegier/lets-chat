//
//  Messages.swift
//  lets-talk
//
//  Created by Stefan de Gier on 20/05/2023.
//

import Foundation

struct Message {
    
    let message: String
    let type: MessageType
    
    init(message: String, type: MessageType) {
        self.message = message
        self.type = type
    }

}
