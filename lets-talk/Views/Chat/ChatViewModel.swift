//
//  ChatViewModel.swift
//  lets-talk
//
//  Created by Stefan de Gier on 19/05/2023.
//

import Foundation
import OpenAISwift


class ChatViewModel {
    
    let messageRepository = MessageRepository()
    let profileRepository = ProfileRepository()
    let buddyRepository = BuddyRepository()
    let openAIService = OpenAIService()
    
    // MARK: Properties
    
    public var messages: [Message] = []
    public var newMessagesCount: Int = 20
    private var messageID: Int64?
    public var messageType: MessageType?
    private var hasSolution: Bool? = false
    private var preparedChatMessages: [ChatMessage]?
    public var respondMessage: String?
    public var openAIServiceError: Bool = false

    // MARK: Computed Properties
    
    private var profileName: String {
        return self.getProfileName()
    }
    
    private lazy var cachedBuddy: Buddy = {
        return self.getBuddy()
    }()

    private var buddy: Buddy {
        return self.cachedBuddy
    }
    
    public var buddyName: String {
        return self.buddy.name
    }
    
    private var buddyLanguage: String {
        return self.buddy.language.rawValue
    }
    
    private var buddyPersonality: String {
        return self.buddy.personality.rawValue
    }
    
    private var buddyPersonalityOptional: String {
        return self.buddy.personalityOptional.rawValue
    }
    
    public var messageText: String? {
        didSet {
            self.messageText = messageText?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
//    private var systemMessage: String {
//        return "Act as a real friend which try to understand and has empathy You wil not give specific instructions. Your main goal is not to give a straight answer but rather to comfort your friend. Your name is: \(self.buddyName) Their name is: \(self.profileName) Your language is ONLY: \(self.buddyLanguage). Max words in your response: 60. Use sometimes emoji's"
//    }

    private var systemMessage: String {
        return "Act as a real friend which is \(self.buddyPersonality) and \(self.buddyPersonalityOptional). You will not give specific instructions. Your main goal is not to give a straight answer but rather to comfort your friend. Your name is: \(self.buddyName). Their name is: \(self.profileName). Your language is ONLY: \(self.buddyLanguage). Max words in your response: 60. Use sometimes emoji's"
    }
    public var initialMessage: String {
        return "Hello \(self.profileName), how are your doing today?"
    }
    
    init() {
        self.fetchMessages()
    }
        
    //MARK: Methods
    
    private func getProfileName() -> String {
        let result = self.profileRepository.getName()
        switch result {
        case .success(let name):
            return name
        case .failure(let error):
            print("Unable to get buddy \(error)")
            return "Unknown"
        }
    }
    
    private func getBuddy() -> Buddy {
        let result = self.buddyRepository.getBuddy()
        switch result {
        case .success(let buddy):
            return buddy
        case .failure(let error):
            print("Unable to get buddy \(error)")
            return Buddy(name: "Unknown", language: .none, personality: .none, personalityOptional: .none)
        }
    }
    
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
            if !self.openAIServiceError {
                self.messageText = self.respondMessage
                self.messageType = .receiver
                self.saveNewMessage()
            }
        }
    }
    
    private func prepareRespondMessagePayload() async -> Void { //TODO: make a more effiecent wat for this
        if let startID = self.messages.last?.id {
            let result: [Message] = self.getBatchOfMessages(startingID: startID, numberOfItems: 10, sortOrder: .orderedDescending)
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
                }
                // Save the new respond in the messageRepo
                // Place the new respond message in the messages datasource
            case .failure(let error):
                // Handle the error
                self.openAIServiceError = true
                print("Error:", error)
            }
        }
    }
}
