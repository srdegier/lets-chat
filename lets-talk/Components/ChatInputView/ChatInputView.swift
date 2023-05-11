//
//  ChatInputView.swift
//  lets-talk
//
//  Created by Stefan de Gier on 07/05/2023.
//

import Foundation
import UIKit

protocol ChatInputViewDelegate: AnyObject {
    func sendButtonIsPressed(_ chatInputView: ChatInputView, finishedMessage: String?)
}

class ChatInputView: UIView, UITextViewDelegate {
    
    @IBOutlet weak private var textContainerView: UIView! {
        didSet {
            self.textContainerView.layer.cornerRadius = 18
            self.textContainerView.layer.borderWidth = 1
            self.textContainerView.layer.borderColor = UIColor.systemGray.cgColor
        }
    }
    
    @IBOutlet weak private var textView: UITextView! {
        didSet {
            self.textView.delegate = self
         }
    }
    
    @IBOutlet weak private var placeholderLabel: UILabel!
    @IBOutlet weak private var textViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak private var sendButton: UIButton! {
        didSet {
            self.sendButton.isEnabled = self.sendButtonisEnabled
        }
    }
    
    // MARK: - Computed properties
    
    private var textViewContentHeight: CGFloat {
        return self.textViewContentSize().height
    }
    
    private lazy var textViewMaxHeight: CGFloat = {
        return self.textView.font!.lineHeight * self.allowedTextLines
    }()
    
    private var textViewNewHeight: CGFloat {
        return min(self.textViewContentHeight, self.textViewMaxHeight)
    }
    
    private var isTextViewAtMaxHeight: Bool {
        return self.textViewNewHeight >= self.textViewMaxHeight
    }
    
    private var isTextViewHeightNotEqualToNewHeight: Bool {
        return textViewHeight.constant != textViewNewHeight
    }

    // MARK: - Properties
    
    weak public var delegate: ChatInputViewDelegate?
    
    public var currentMessage: String? {
        didSet {
            self.updateView()
        }
    }
    
    public var allowedTextLines: CGFloat = 5 {
        didSet {
            self.updateView()
        }
    }
    
    public var sendButtonisEnabled: Bool = true {
        didSet {
            self.sendButton.isEnabled = self.sendButtonisEnabled
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ChatInputView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    override var intrinsicContentSize: CGSize {
        return self.textViewContentSize()
    }
        
    private func setupView() -> Void {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    // MARK: Methods
    
    private func updateView() {
        
        // if empty, delete textView text
        if (self.currentMessage == nil){
            self.textView.text = nil
        }
        
        self.sendButton.isEnabled = self.sendButtonisEnabled
        
        if self.isTextViewHeightNotEqualToNewHeight {
            self.textViewHeight.constant = self.textViewNewHeight
            self.layoutIfNeeded()
        }
        
        self.placeholderLabel.isHidden = !self.textView.text.isEmpty
        
        self.textView.isScrollEnabled = self.isTextViewAtMaxHeight
    }
        
    private func textViewContentSize() -> CGSize {
        let size = CGSize(width: textView.bounds.width,
                          height: CGFloat.greatestFiniteMagnitude)
     
        let textSize = textView.sizeThatFits(size)
        return CGSize(width: bounds.width, height: textSize.height)
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        self.currentMessage = textView.text
    }
    
    @IBAction func sendButtonIsPressed(_ sender: Any) {
        self.delegate?.sendButtonIsPressed(self, finishedMessage: self.currentMessage)
    }
    
}
