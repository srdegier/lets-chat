//
//  MessageBubbleView.swift
//  lets-talk
//
//  Created by Stefan de Gier on 24/04/2023.
//

import Foundation
import UIKit

enum MessageType: Int {
    case sender
    case receiver
    // case system
}

class MessageBubbleView: UIView {
        
    @IBOutlet weak var textBubbleViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var textBubbleViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var textBubbleViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatBubbleImage: UIImageView!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var textBubbleView: UIView!
    
    // MARK: - Properties
    
    private var _messageType: MessageType = .sender

    @IBInspectable public var messageType: Int {
        get { _messageType.rawValue }
        set {
            _messageType = MessageType(rawValue: newValue) ?? .sender
        }
    }
    
    private var _isChatMode: Bool = true
    
    @IBInspectable public var isChatMode: Bool {
        get { _isChatMode }
        set {
            _isChatMode = newValue
        }
    }
    
    private var _chatMessage: String?
    
    @IBInspectable public var chatMessage: String? {
        get { _chatMessage }
        set {
            _chatMessage = newValue
            self.messageTextLabel.text = newValue
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateView()
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MessageBubbleView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func setupView() {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    // MARK: - Layout
    
    private func updateView() {
        print("Test", self.isChatMode)
        switch messageType {
            case messageTypeToInt(.receiver):
                self.changeImage("chat_bubble_received")
                self.chatBubbleImage.tintColor = .systemGray4
                self.messageTextLabel.textColor = .black
                if let constraint = self.textBubbleViewTrailingConstraint, self.isChatMode {
                    constraint.isActive = false
                    print("left")
                }

            case messageTypeToInt(.sender):
                self.changeImage("chat_bubble_sent")
                self.chatBubbleImage.tintColor = .systemBlue
                self.messageTextLabel.textColor = .white
                if let constraint = self.textBubbleViewLeadingConstraint, self.isChatMode {
                    constraint.isActive = false
                    print("right")
                }
            default:
                print("no messageType entered")
            }
        
        let screenWidth = UIScreen.main.bounds.size.width
        if isChatMode {
            self.textBubbleViewWidthConstraint.constant = screenWidth * 0.90
            print("AI")
        }
        else {
            self.textBubbleViewWidthConstraint.constant = screenWidth
            print("AIhehe")
        }
    }
    
    // MARK: - Methods
    
    private func changeImage(_ name: String) {
        guard let image = UIImage(named: name) else { return }
        self.chatBubbleImage.image = image
            .resizableImage(withCapInsets:
                                UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21),
                                    resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
    }
    
    // Helper function to convert from MessageType to Int
    private func messageTypeToInt(_ type: MessageType) -> Int {
        return type.rawValue
    }
        
}
