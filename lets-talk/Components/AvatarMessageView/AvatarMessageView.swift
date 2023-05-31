//
//  AvatarMessageView.swift
//  lets-talk
//
//  Created by Stefan de Gier on 02/05/2023.
//

import Foundation
import UIKit
import Lottie

class AvatarMessageView: UIView {
    
    @IBOutlet weak var avatarAnimationViewXConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarMessageViewContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarAnimationView: LottieAnimationView!
    @IBOutlet weak var messageBubbleView: MessageBubbleView!
    @IBOutlet weak var messageBubbleViewTopConstraint: NSLayoutConstraint!
    
    private var _avatarMessageText: String?
    
    public var avatarMessageText: String? {
        get { _avatarMessageText }
        set {
            _avatarMessageText = newValue
            self.messageBubbleView.chatMessage = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AvatarMessageView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    private func setupView() {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        self.messageBubbleView.alpha = 0
        self.messageBubbleView.isTailFlipped = true
    }
    
    override func layoutSubviews() {
        //self.frame.size.height = 1000
//        self.avatarMessageViewContainerHeightConstraint.constant = self.messageBubbleView.bounds.size.height + 50
    }
    
    public func startAnimation() -> Void {
        if let centerXConstraint = self.avatarAnimationViewXConstraint {
            UIView.animate(withDuration: 1.0, animations: {
                centerXConstraint.isActive = false
                self.layoutIfNeeded()
            }) {_ in
                self.avatarAnimationView.loopMode = .loop
                self.avatarAnimationView.play()
                UIView.animate(withDuration: 0.5) {
                    let messageHeight = self.messageBubbleView.frame.size.height + self.messageBubbleViewTopConstraint.constant
                    if self.avatarAnimationView.frame.size.height >= messageHeight {
                        print("messageheight is te klein")
                    } else {
                        self.avatarMessageViewContainerHeightConstraint.constant = messageHeight
                    }
                    self.layoutIfNeeded()
                }
                // Voeg hier je extra animatie toe
                UIView.animate(withDuration: 0.4) {
                    self.messageBubbleView.alpha = 1
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
}


