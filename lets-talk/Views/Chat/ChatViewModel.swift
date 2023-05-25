//
//  ChatViewModel.swift
//  lets-talk
//
//  Created by Stefan de Gier on 19/05/2023.
//

import Foundation
import OpenAISwift

class ChatViewModel {
    
    var messages: [Message] = [
//        Message(message: "If you see this messages the messages has failed to be load", type: .receiver),
    ]
    
    var newMessagesCount: Int = 20
    
    let messageRepository = MessageRepository()
    let openAIService = OpenAIService()
    
    // MARK: Properties
    
    var messageID: Int64?

    var messageText: String? {
        didSet {
            self.messageText = messageText?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    var messageType: MessageType?
    var hasSolution: Bool? = false
    
    var preparedChatMessages: [ChatMessage]?
    let systemMessage: String = "Act as a real friend which try to understand and has empathy. Your main goal is not to give a straight answer but rather to comfort your friend. This is your main goal"
    var respondMessage: String?
    
    init() {
        self.fetchMessages()
    }
        
    // MARK: Methods
    
    public func saveNewMessage() {
        guard let messageText = self.messageText, let messageType = self.messageType, let hasSolution = self.hasSolution else {
            return
        }
        // Voeg nieuw bericht toe aan berichtenrepository
        if let messageTypeRawValue = self.messageType?.rawValue {
            let result = self.messageRepository.addMessage(text: messageText, type: messageTypeRawValue, solution: hasSolution)
            
            switch result {
            case .success(let rowId):
                self.messageID = rowId
            case .failure(let error):
                print("Fout bij het toevoegen van het bericht: \(error)")
            }
        }
        // Voeg nieuw bericht toe aan datasource
        if let messageID = self.messageID {
            self.messages.append(Message(id: messageID, message: messageText, type: messageType))
        }
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
    
    public func addNewRespondMessage() async {
        // Prepare payload
        await self.prepareRespondMessagePayload()
        // Fetch new response
        if (self.preparedChatMessages != nil) {
            await self.fetchRespondMessage()
            self.messageText = self.respondMessage
            self.messageType = .receiver
            self.saveNewMessage()
        }
    }
    
    private func prepareRespondMessagePayload() async -> Void { //TODO: make a more effiecent wat for this
        if let startID = self.messages.last?.id {
            let result: [Message] = self.getBatchOfMessages(startingID: startID, numberOfItems: 20, sortOrder: .orderedDescending)
            var preparedChatMessages = result.map { message -> ChatMessage in
                let chatRole: ChatRole
                switch message.type {
                case .sender:
                    chatRole = .user
                case .receiver:
                    chatRole = .assistant
                }
                return ChatMessage(role: chatRole, content: message.message)
            }
            let systemMessage = ChatMessage(role: .system, content: self.systemMessage)
            preparedChatMessages.insert(systemMessage, at: 0)
            self.preparedChatMessages = preparedChatMessages
        }
    }

    
    private func getBatchOfMessages(startingID: Int64, numberOfItems: Int, sortOrder: ComparisonResult) -> [Message] {
        var filteredArray = [Message]()
        if sortOrder == .orderedAscending {
            let startIndex = self.messages.firstIndex { $0.id == startingID } ?? 0
            let endIndex = min(startIndex + numberOfItems, self.messages.count)
            filteredArray = Array(self.messages[startIndex..<endIndex])
        } else {
            let startIndex = self.messages.lastIndex { $0.id == startingID } ?? self.messages.count - 1
            let endIndex = max(startIndex - numberOfItems, -1)
            filteredArray = Array(self.messages[(endIndex + 1)...startIndex])
        }
        return filteredArray
    }

    private func fetchRespondMessage() async {
        if let payloadData = self.preparedChatMessages {
            let respondResult = await self.openAIService.fetchRespond(payload: payloadData)
            switch respondResult {
            case .success(let respondMessage):
                // Handle the successful response
                if let messageContent = respondMessage.choices?.first?.message.content {
                    self.respondMessage = messageContent
                    print("Respond Message:", messageContent)
                }
                // Save the new respond in the messageRepo
                // Place the new respond message in the messages datasource
            case .failure(let error):
                // Handle the error
                print("Error:", error)
            }
        }
    }
}
