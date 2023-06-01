//
//  ChatCollectionView.swift
//  lets-talk
//
//  Created by Stefan de Gier on 22/05/2023.
//

import Foundation
import UIKit

class ChatCollectionView: UICollectionView {
    
    override func reloadData() {
        super.reloadData()
    }
    
    public func scrollToBottom(withoutDelay: Bool = false) {

        if !withoutDelay {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.scrollToItemBottom()
                self.layoutIfNeeded()
            }
        } else {
            self.scrollToItemBottom()
            print("In de else")
        }

    }
    
    private func scrollToItemBottom() {
        let lastItemIndex = self.numberOfItems(inSection: 0) - 1
        let lastMessageIndex = IndexPath(item: lastItemIndex, section: 0)
        self.scrollToItem(at: lastMessageIndex, at: .bottom, animated: false)
        self.layoutIfNeeded()
    }
}
