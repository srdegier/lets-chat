//
//  ChatInputView.swift
//  lets-talk
//
//  Created by Stefan de Gier on 07/05/2023.
//

import Foundation
import UIKit

class ChatInputView: UIView, UITextViewDelegate {
    
    
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    // MARK: - Properties
    
    override var intrinsicContentSize: CGSize {
        return textViewContentSize()
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
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ChatInputView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    internal override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.delegate = self
    }
    
    private func setupView() -> Void {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        self.textContainerView.layer.cornerRadius = 18
        self.textContainerView.layer.borderWidth = 1
        self.textContainerView.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    // MARK: Methods
        
    func textViewContentSize() -> CGSize {
        let size = CGSize(width: textView.bounds.width,
                          height: CGFloat.greatestFiniteMagnitude)
     
        let textSize = textView.sizeThatFits(size)
        return CGSize(width: bounds.width, height: textSize.height)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.placeholderLabel.isHidden = !textView.text.isEmpty
        let contentHeight = self.textViewContentSize().height
        
        // Limit to 5 lines
        let maxHeight = textView.font!.lineHeight * 5
        let newHeight = min(contentHeight, maxHeight)
        
        if self.textViewHeight.constant != newHeight {
            self.textViewHeight.constant = newHeight
            self.layoutIfNeeded()
            
            // Enable scrolling if content height exceeds 5 lines
            self.textView.isScrollEnabled = newHeight >= maxHeight
        }
    }

}
