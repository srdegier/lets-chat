//
//  ChatCollectionViewCell.swift
//  lets-talk
//
//  Created by Stefan de Gier on 18/05/2023.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var messageBubbleView: MessageBubbleView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    func configure(with messageID: Int64, chatMessage: String, isChatMode: Bool, messageType: MessageType) {
        self.messageBubbleView.messageID = messageID
        self.messageBubbleView.chatMessage = chatMessage
        self.messageBubbleView.isChatMode = isChatMode
        self.messageBubbleView.messageType = messageType
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        let messageBubbleHeight = self.messageBubbleView.textBubbleView.bounds.height
        let desiredHeight = messageBubbleHeight
        
        attributes.size.height = desiredHeight + 15
        
        return attributes
    }
}


