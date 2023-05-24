//
//  ChatViewController.swift
//  lets-talk
//
//  Created by Stefan de Gier on 23/04/2023.
//

import Foundation
import UIKit

class ChatViewController: UIViewController, ChatInputViewDelegate {

    @IBOutlet weak var chatView: ChatView!
    
    private let viewModel = ChatViewModel()
    private var chatViewDatasource: ChatDataSource?
    private var chatViewDelegate: ChatDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Chat"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.chatView.chatInputView.delegate = self
        self.chatView.chatInputView.allowedTextLines = 3
        
        self.chatViewDatasource = ChatDataSource(viewModel: self.viewModel)
        self.chatViewDelegate = ChatDelegate(viewModel: self.viewModel)
        self.chatView.chatCollectionViewDataSource = self.chatViewDatasource
        self.chatView.chatCollectionViewDelegate = self.chatViewDelegate
    }
    
    // MARK: Methods
    
    func sendButtonIsPressed(_ chatInputView: ChatInputView, finishedMessage: String?) {
        // remove text from chatinputview
        self.chatView.chatInputView.currentMessage = nil
        // disable chatinputview button
        self.chatView.chatInputView.sendButtonisEnabled = false

        if let message = finishedMessage {
            // TODO: make function to be readable
            self.sendMessage(message: message)
            
            // TODO: make function to be readable
            // call viewmodel function for getting the message back and place it in the array
            // self.viewModel.respondMessage() // receiveMessage?
            // update the collectionview
            // enable chatinputview button
        }

        self.chatView.chatInputView.sendButtonisEnabled = true
    }
    
    private func sendMessage(message: String) {
        self.viewModel.messageText = message
        self.viewModel.messageType = .sender
        // call viewmodel function for to add message to messages array
        self.viewModel.addNewMessage()
        // perform a batch update to add the new message
        self.chatView.addNewMessageToChat()
    }
    
}
