//
//  ChatViewController.swift
//  lets-talk
//
//  Created by Stefan de Gier on 23/04/2023.
//

import Foundation
import UIKit

class ChatViewController: UIViewController, ChatInputViewDelegate {

    @IBOutlet weak var avatarMessageView: AvatarMessageView!
    @IBOutlet weak var chatView: ChatView!
    
    private let viewModel = ChatViewModel()
    private var chatViewDatasource: ChatDataSource?
    private var chatViewDelegate: ChatDelegate?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Chat"
        self.navigationItem.largeTitleDisplayMode = .never
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.chatView.chatInputView.delegate = self
        self.chatView.chatInputView.allowedTextLines = 3
        
        self.chatViewDatasource = ChatDataSource(viewModel: self.viewModel)
        self.chatViewDelegate = ChatDelegate(viewModel: self.viewModel)
        self.chatView.chatCollectionViewDataSource = self.chatViewDatasource
        self.chatView.chatCollectionViewDelegate = self.chatViewDelegate
        
        self.avatarMessageView.messageBubbleView.messageType = .receiver
        self.avatarMessageView.avatarMessageText = "Hoi Stefan, hoe is het met je vandaag?"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.avatarMessageView.revealAnimation()
        self.avatarMessageView.slideAvatarViewAnimation() {
            self.avatarMessageView.revealMessageAnimation()
        }
    }
    
    // MARK: Methods
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        self.avatarMessageView.hideAnimation() {
            if (self.viewModel.messageText != nil) {
                self.chatView.addNewMessageToChat()
                self.viewModel.messageText = nil
            }
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        //self.avatarMessageView.revealAnimation()
    }
    
    func sendButtonIsPressed(_ chatInputView: ChatInputView, finishedMessage: String?) {
        // remove text from chatinputview
        self.chatView.chatInputView.currentMessage = nil
        // disable chatinputview button
        if let message = finishedMessage {
            self.chatView.chatInputView.sendButtonisEnabled = false
            self.sendMessage(message: message)
        }
        self.avatarMessageView.slideRevertViewAnimation()
        self.avatarMessageView.hideMessageAnimation() {
            Task {
                // do the animation where it is typing
                self.avatarMessageView.slideRevertViewAnimation()
                self.avatarMessageView.changeAnimation(fileName: "chatting")
                
                await self.sendRespondMessage()
                self.avatarMessageView.avatarMessageText = self.viewModel.respondMessage
                self.avatarMessageView.changeAnimation(fileName: "avatar-2")
                self.avatarMessageView.slideAvatarViewAnimation() {
                    self.avatarMessageView.revealMessageAnimation()
                }
                self.chatView.chatInputView.sendButtonisEnabled = true
            }
        }

    }
    
    private func sendMessage(message: String) {
        self.viewModel.messageText = message
        self.viewModel.messageType = .sender
        // call viewmodel function for to add message to messages array
        self.viewModel.saveNewMessage()

        // perform a batch update to add the new message
        self.chatView.addNewMessageToChat()
    }
    
    private func sendRespondMessage() async {
        await self.viewModel.addNewRespondMessage()
    }
}
