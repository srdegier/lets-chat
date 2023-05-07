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
    
    @IBOutlet weak var avatarAnimationView: LottieAnimationView!
    @IBOutlet weak var messageBubbleView: MessageBubbleView!
    @IBOutlet weak var centerXConstraint: NSLayoutConstraint!
    
    private var _avatarMessageText: String?

    public var avatarMessageText: String? {
        get { _avatarMessageText }
        set {
            _avatarMessageText = newValue
            self.messageBubbleView.chatMessage = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AvatarMessageView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    private func setupView() -> Void {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        self.messageBubbleView.alpha = 0
        self.messageBubbleView.isTailFlipped = true
    }
    
    public func startAnimation() -> Void {
        if self.avatarMessageText != nil {
            if let centerXConstraint = self.centerXConstraint {
                UIView.animate(withDuration: 1.0, animations: {
                    centerXConstraint.isActive = false
                    self.layoutIfNeeded()
                }) {_ in
                    self.avatarAnimationView.loopMode = .loop
                    self.avatarAnimationView.play()
                    UIView.animate(withDuration: 0.5) {
                        self.messageBubbleView.alpha = 1
                    }
                }
            }
        }
    }

}

