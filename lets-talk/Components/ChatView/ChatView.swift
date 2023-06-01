//
//  ChatView.swift
//  lets-talk
//
//  Created by Stefan de Gier on 17/05/2023.
//

import Foundation
import UIKit

class ChatView: UIView {

    @IBOutlet weak var chatContainerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatCollectionView: ChatCollectionView! {
        didSet {
            self.chatCollectionView.register(UINib(nibName: "ChatCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MessageType.sender.rawValue)
            self.chatCollectionView.register(UINib(nibName: "ChatCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MessageType.receiver.rawValue)
        }
    }

    @IBOutlet weak var chatInputView: ChatInputView!
    
    // MARK: Properties
    
    var chatCollectionViewDataSource: ChatDataSourceProtocol? {
         didSet {
            self.chatCollectionView.dataSource = self.chatCollectionViewDataSource
        }
    }
    
    var chatCollectionViewDelegate: ChatDelegateProtocol? {
         didSet {
             self.chatCollectionView.delegate = self.chatCollectionViewDelegate
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ChatView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    private func setupView() {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        if let flowLayout = chatCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: chatCollectionView.bounds.width, height: 50)
        }
        self.chatCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Force developer to use the chatCollectionViewDataSource
        guard chatCollectionViewDataSource != nil else {
            fatalError("chatCollectionViewDataSource is not set.")
        }
        guard chatCollectionViewDelegate != nil else {
            fatalError("chatCollectionViewDelegate is not set.")
        }
        self.chatCollectionView.scrollToBottom(withoutDelay: true)
    }
    
    // MARK: Methods
    
    public func addNewMessageToChat() {
        // Bepaal de index van het nieuwe bericht in de gegevensbron
        let newIndex = self.chatCollectionView.numberOfItems(inSection: 0)
        // Maak het indexpad voor het nieuwe bericht
        let indexPath = IndexPath(item: newIndex, section: 0)
        // Voeg het nieuwe item toe aan de UICollectionView
        self.chatCollectionView.performBatchUpdates({
            self.chatCollectionView.insertItems(at: [indexPath])
            self.layoutSubviews()
        }, completion: { _ in
            self.chatCollectionView.scrollToBottom()
        })
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            self.chatContainerViewBottomConstraint.constant = keyboardHeight
            self.chatCollectionView.scrollToBottom()
            self.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        self.chatContainerViewBottomConstraint.constant = 0
        self.layoutIfNeeded()
    }
    
    @objc private func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        endEditing(true)
    }

}
