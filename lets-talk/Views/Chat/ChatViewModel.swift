//
//  ChatViewModel.swift
//  lets-talk
//
//  Created by Stefan de Gier on 19/05/2023.
//

import Foundation

class ChatViewModel {
    
    var messages: [Message] = [
//        Message(message: "If you see this messages the messages has failed to be load", type: .receiver),
    ]
    
    var newMessagesCount: Int = 20
    
    let messageRepository = MessageRepository()
    
    // MARK: Properties

    var messageText: String? {
        didSet {
            self.messageText = messageText?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    var messageType: MessageType?
    var hasSolution: Bool? = false
    
    init() {
        self.fetchMessages()
    }
        
    // MARK: Methods
    
    public func addNewMessage() {
        guard let messageText = self.messageText, let messageType = self.messageType, let hasSolution = self.hasSolution else {
            return
        }
        // add new message to messages repo
        if let messageTypeRawValue = self.messageType?.rawValue {
            self.messageRepository.addMessage(text: messageText, type: messageTypeRawValue, solution: hasSolution)
        }
        // add new message to datasource
        self.messages.append(Message(message: messageText, type: messageType))
        
    }
    
    public func fetchMessages() {
        do {
            let fetchedMessages = try messageRepository.getMessages()
            self.newMessagesCount = fetchedMessages.count
            self.messages.insert(contentsOf: fetchedMessages, at: 0) // Voeg de nieuwe berichten toe aan het begin van de array
        } catch {
            print("!@Error fetching messages: \(error)")
        }
    }
    
}
