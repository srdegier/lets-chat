//
//  ChatViewController.swift
//  lets-talk
//
//  Created by Stefan de Gier on 23/04/2023.
//

import Foundation
import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var avatarMessageView: AvatarMessageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Chat"
        print("ChatViewController")
    }
    
}
