//
//  HistoryViewModel.swift
//  lets-talk
//
//  Created by Stefan de Gier on 12/06/2023.
//

import Foundation

class HistoryViewModel {
    let messageRepository = MessageRepository()
    
    public func deleteChat() {
        self.messageRepository.deleteMessages()
    }
}
