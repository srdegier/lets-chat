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
    private var datasource: ChatDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Chat"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.datasource = ChatDataSource(viewModel: self.viewModel)
        self.chatView.chatCollectionViewDataSource = self.datasource
        self.chatView.chatInputView.delegate = self

    }
    
    // MARK: Methods
    
    func sendButtonIsPressed(_ chatInputView: ChatInputView, finishedMessage: String?) {
        print("SIUUUUUUU")
        // remove text from chatinputview
        self.chatView.chatInputView.currentMessage = nil
        // disable chatinputview button
        self.chatView.chatInputView.sendButtonisEnabled = false
        //self.viewModel.sendMessage()
        if let message = finishedMessage {
            // TODO: make function to be readable
            self.viewModel.messageText = message
            self.viewModel.messageType = .sender
            
            // call viewmodel function for to add message to messages array
            self.viewModel.addNewMessage()
            // add newly add datasource to chatview
           // self.chatView.chatData = self.viewModel.messages
            // perform a batch update to add the new message
            self.chatView.addNewMessageToChat()
            
            // TODO: make function to be readable
            // call viewmodel function for getting the message back and place it in the array
            // self.viewModel.respondMessage() // receiveMessage?
            // update the collectionview
            // enable chatinputview button
        }

        self.chatView.chatInputView.sendButtonisEnabled = true
    }
    
}
