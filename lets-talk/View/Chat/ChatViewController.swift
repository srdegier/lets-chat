//
//  ChatViewController.swift
//  lets-talk
//
//  Created by Stefan de Gier on 23/04/2023.
//

import Foundation
import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatView: ChatView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Chat"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        let chatData: [(message: String, messageType: MessageType)] = [
            ("Super test bericht", .receiver),
            ("Nog een test berichtNog een test berichtNog een test berichtNog een test berichtNog een test berichtNog een test berichtNog een test bericht", .sender),
            ("Een ander lang bericht soort van grapje", .receiver),
            ("Een ander lang bericht soort van grapjegrapjegrapjegrapjegrapje", .sender),
            ("Super test bericht", .receiver),
            ("Super test bericht", .receiver),
            ("Nog een test berichtNog een test berichtNog een test berichtNog een test berichtNog een test berichtNog een test berichtNog een test bericht", .sender),
            ("Een ander lang bericht soort van grapje", .receiver),
            ("Een ander lang bericht soort van grapjegrapjegrapjegrapjegrapje", .sender),
            ("Super test bericht", .receiver),
            ("Super test bericht", .receiver),
            ("Nog een test berichtNog een test berichtNog een test berichtNog een test berichtNog een test berichtNog een test berichtNog een test bericht", .sender),
            ("Een ander lang bericht soort van grapje", .receiver),
            ("Een ander lang bericht soort van grapjegrapjegrapjegrapjegrapje", .sender),
            ("Super test bericht", .receiver),
            ("Super test bericht", .receiver),
            ("Nog een test berichtNog een test berichtNog een test berichtNog een test berichtNog een test berichtNog een test berichtNog een test bericht", .sender),
            ("Een ander lang bericht soort van grapje", .receiver),
            ("Een ander lang bericht soort van grapjegrapjegrapjegrapjegrapje", .sender),
            ("Super test bericht", .receiver),
            
        ]
        self.chatView.chatData = chatData
    }
    
}
