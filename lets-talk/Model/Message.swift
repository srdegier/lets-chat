//
//  Messages.swift
//  lets-talk
//
//  Created by Stefan de Gier on 20/05/2023.
//

import Foundation

struct Message {
    let id: Int64
    let message: String
    let type: MessageType
    
    init(id: Int64, message: String, type: MessageType) {
        self.id = id
        self.message = message
        self.type = type
    }

}
