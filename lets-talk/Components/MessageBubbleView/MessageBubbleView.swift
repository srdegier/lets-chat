//
//  MessageBubbleView.swift
//  lets-talk
//
//  Created by Stefan de Gier on 24/04/2023.
//

import Foundation
import UIKit

enum MessageType: String {
    case sender = "sender"
    case receiver = "receiver"
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
    
    // TODO: Remove inspectables
    
    public var messageID: Int64?
    
    public var messageType: MessageType = .sender {
        didSet {
            self.updateViewByMessageType()
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
    
    private var _isTailFlipped: Bool = false
    
    @IBInspectable public var isTailFlipped: Bool {
        get { _isTailFlipped }
        set {
            _isTailFlipped = newValue
            self.updateView()
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
        self.updateView()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MessageBubbleView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    private func setupView() {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    // MARK: - Layout
    
    private func updateView() {
        if self.isChatMode {
            let screenWidth = UIScreen.main.bounds.size.width
            self.textBubbleViewWidthConstraint.constant = screenWidth * 0.90
        }
        
        if self.isTailFlipped {
            self.flipBubbleImage()
        }
        self.layoutIfNeeded()
    }
    
    // MARK: - Methods
    
    private func updateViewByMessageType() {
        switch self.messageType {
        case .receiver:
            self.changeImage("chat_bubble_received")
            self.chatBubbleImage.tintColor = .systemGray4
            self.messageTextLabel.textColor = .black
            if let textBubbleViewLeadingConstraint = self.textBubbleViewLeadingConstraint, let textBubbleViewTrailingConstraint = self.textBubbleViewTrailingConstraint {
                self.updateViewConstraint(textBubbleViewLeadingConstraint, relation: .equal)
                self.updateViewConstraint(textBubbleViewTrailingConstraint, relation: .greaterThanOrEqual)
                self.textBubbleView.semanticContentAttribute = .forceLeftToRight
            }
        case .sender:
            self.changeImage("chat_bubble_sent")
            self.chatBubbleImage.tintColor = .systemBlue
            self.messageTextLabel.textColor = .white
            if let textBubbleViewLeadingConstraint = self.textBubbleViewLeadingConstraint, let textBubbleViewTrailingConstraint = self.textBubbleViewTrailingConstraint {
                self.updateViewConstraint(textBubbleViewTrailingConstraint, relation: .equal)
                self.updateViewConstraint(textBubbleViewLeadingConstraint, relation: .greaterThanOrEqual)
                self.textBubbleView.semanticContentAttribute = .forceRightToLeft
            }
        }
        self.layoutIfNeeded()
    }
    
    private func updateViewConstraint(_ existingConstraint: NSLayoutConstraint, relation: NSLayoutConstraint.Relation) -> Void { // make helper function later.
        if let superview = superview {
            let newConstraint = NSLayoutConstraint(item: existingConstraint.firstItem as Any, attribute: existingConstraint.firstAttribute, relatedBy: relation, toItem: existingConstraint.secondItem, attribute: existingConstraint.secondAttribute, multiplier: existingConstraint.multiplier, constant: existingConstraint.constant)
            
            existingConstraint.isActive = false
            superview.addConstraint(newConstraint)
        }
    }
    
    private func changeImage(_ name: String) {
        guard let image = UIImage(named: name) else { return }
        self.chatBubbleImage.image = image
            .resizableImage(withCapInsets:
                                UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21),
                                    resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
    }
    
    private func flipBubbleImage() {
        let transform = CATransform3DMakeScale(1, -1, 1)
        self.chatBubbleImage.layer.transform = transform
    }
        
}
