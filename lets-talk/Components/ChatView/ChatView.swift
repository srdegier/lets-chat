//
//  ChatView.swift
//  lets-talk
//
//  Created by Stefan de Gier on 17/05/2023.
//

import Foundation
import UIKit

class ChatView: UIView {

    @IBOutlet weak var chatCollectionView: UICollectionView! {
        didSet {
            // Registreer de cel voor de collectionView
            self.chatCollectionView.register(UINib(nibName: "ChatCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        }
    }
    
    @IBOutlet weak var chatInputView: ChatInputView!
    
    // MARK: Properties
    
    var chatCollectionViewDataSource: ChatDataSourceProtocol! {
         didSet {
            self.chatCollectionView.dataSource = self.chatCollectionViewDataSource
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
        let nib = UINib(nibName: "ChatView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    private func setupView() {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        //check if datasource is set
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        self.chatCollectionView.collectionViewLayout = layout
        self.chatCollectionView.showsVerticalScrollIndicator = false
        self.chatCollectionView.showsHorizontalScrollIndicator = false
        
        self.chatCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Force developer to use the chatCollectionViewDataSource
        guard chatCollectionViewDataSource != nil else {
            fatalError("chatCollectionViewDataSource is not set.")
        }
        self.scrollToBottom()
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
        }, completion: nil)
        self.scrollToBottom()
    }
    
    private func scrollToBottom() {
        let lastItemIndex = self.chatCollectionView.numberOfItems(inSection: 0) - 1
        let lastMessageIndex = IndexPath(item: lastItemIndex, section: 0)
        self.chatCollectionView.scrollToItem(at: lastMessageIndex, at: .bottom, animated: false)
    }
}
