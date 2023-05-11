//
//  ChatViewController.swift
//  lets-talk
//
//  Created by Stefan de Gier on 23/04/2023.
//

import Foundation
import UIKit

class ChatViewController: UIViewController, ChatInputViewDelegate {

    @IBOutlet weak var chatInputView: ChatInputView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Chat"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.chatInputView.delegate = self
        self.chatInputView.allowedTextLines = 3
    }
    
    func sendButtonIsPressed(_ chatInputView: ChatInputView, finishedMessage: String?) {
        self.chatInputView.currentMessage = nil
    }
    
}
