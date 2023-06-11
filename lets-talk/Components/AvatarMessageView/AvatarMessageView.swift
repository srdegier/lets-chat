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
        self.avatarMessageViewContainerHeightConstraint.constant = 0
        self.messageBubbleView.alpha = 0
        self.avatarAnimationView.alpha = 0
        self.messageBubbleView.isTailFlipped = true
    }
    
    // MARK: Animations
    
    public func revealAnimation(completion: (() -> Void)? = nil) -> Void {
        UIView.animate(withDuration: 1.0, animations: {
            self.avatarMessageViewContainerHeightConstraint.constant = 200
            self.avatarAnimationView.alpha = 1
            self.contentMode = .top
            self.superview?.layoutIfNeeded()
        }) { (_) in
            self.avatarAnimationView.loopMode = .loop
            self.avatarAnimationView.play()
            completion?()
        }
        
    }
    
    public func hideAnimation(completion: (() -> Void)? = nil) -> Void {
        UIView.animate(withDuration: 1.0, animations: {
            self.avatarMessageViewContainerHeightConstraint.constant = 0
            self.superview?.layoutIfNeeded()
        }) { (_) in
            completion?()
        }
    }
    
    private var originalCenterXConstraint: NSLayoutConstraint?
    
    public func slideAvatarViewAnimation(completion: (() -> Void)? = nil) -> Void {
        if let centerXConstraint = self.avatarAnimationViewXConstraint {
            self.originalCenterXConstraint = centerXConstraint
            UIView.animate(withDuration: 1.0, animations: {
                centerXConstraint.isActive = false
                self.layoutIfNeeded()
            }) { (_) in
                HapticFeedbackManager.shared.performNotificationFeedback(type: .success)
                completion?()
            }
        }
    }
    
    public func slideRevertViewAnimation(completion: (() -> Void)? = nil) -> Void {
        if let centerXConstraint = originalCenterXConstraint {
            UIView.animate(withDuration: 1.0, animations: {
                centerXConstraint.isActive = true
                self.layoutIfNeeded()
            }) { (_) in
                completion?()
            }
            self.originalCenterXConstraint = nil
        }
    }
    
    public func revealMessageAnimation(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            let messageHeight = self.messageBubbleView.frame.size.height + self.messageBubbleViewTopConstraint.constant
            if self.avatarAnimationView.frame.size.height >= messageHeight {
                // do somthing here if you wish
            } else {
                self.avatarMessageViewContainerHeightConstraint.constant = messageHeight + 20
            }
            self.messageBubbleView.alpha = 1
            self.layoutIfNeeded()
        }) { (_) in
            completion?()
        }
    }
    
    public func changeAnimation(fileName: String, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            self.avatarAnimationView.alpha = 0
            self.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 1.0) {
                self.avatarAnimationView.alpha = 1
                self.avatarAnimationView.animation = LottieAnimation.named(fileName)
                self.avatarAnimationView.reloadImages()
                self.avatarAnimationView.loopMode = .loop
                self.avatarAnimationView.play()
                completion?()
            }
        }
    }
    
    public func hideMessageAnimation(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            self.avatarMessageViewContainerHeightConstraint.constant = 220
            self.messageBubbleView.alpha = 0
            self.layoutIfNeeded()
        }) { (_) in
            completion?()
        }
    }

}


