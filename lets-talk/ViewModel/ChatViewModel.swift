//
//  ChatViewModel.swift
//  lets-talk
//
//  Created by Stefan de Gier on 19/05/2023.
//

import Foundation

class ChatViewModel {
    
    var messages: [Message] = [
        (Message(message: "Super test bericht", type: .receiver)),
        (Message(message: "JAAAAAA TOCHHH NIET DANNNN", type: .sender)),
        (Message(message: "Super test bericht", type: .receiver)),
    ]
    
    let messageRepository = MessageRepository()
    
    // MARK: Properties

    var messageText: String? {
        didSet {
            self.messageText = messageText?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    var messageType: MessageType?
    
    var hasSolution: Bool? = false
    
    // MARK: Methods
    
    public func addNewMessage() {
        guard let messageText = self.messageText, let messageType = self.messageType, let hasSolution = self.hasSolution else {
            return
        }
        // add new message to messages repo
        if let messageTypeRawValue = self.messageType?.rawValue {
            self.messageRepository.addMessage(text: messageText, type: messageTypeRawValue, solution: hasSolution)
        }
        // add new message to
        self.messages.append(Message(message: messageText, type: messageType))
        
    }

}
