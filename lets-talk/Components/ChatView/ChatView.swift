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
    
    // MARK: Properties
    
    var chatData: [(message: String, messageType: MessageType)] = []
    
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
        
        self.chatCollectionView.delegate = self
        self.chatCollectionView.dataSource = self

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
        
        // Scroll alleen naar het laatste bericht als er berichten zijn
        guard !chatData.isEmpty else {
            return
        }
        
        let lastMessageIndex = IndexPath(item: chatData.count - 1, section: 0)
        self.chatCollectionView.scrollToItem(at: lastMessageIndex, at: .bottom, animated: false)
    }
}

extension ChatView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = chatCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ChatCollectionViewCell
        let chatMessage = self.chatData[indexPath.item].message
        let messageType = self.chatData[indexPath.item].messageType
        cell?.configure(with: chatMessage, isChatMode: true, messageType: messageType)
        return cell!
    }

}
