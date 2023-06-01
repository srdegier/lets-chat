//
//  ChatDelegate.swift
//  lets-talk
//
//  Created by Stefan de Gier on 22/05/2023.
//

import Foundation
import UIKit

class ChatDelegate: NSObject, ChatDelegateProtocol {
    var viewModel: ChatViewModel
    var ignoreFirstWillDisplay: Bool = true
    var mayLoadNextBatch: Bool = true
    
    required init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
    }
        
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            if !self.ignoreFirstWillDisplay, self.mayLoadNextBatch {
            
                self.viewModel.fetchMessages()
                self.mayLoadNextBatch = false
               
                let section = 0
                let amount = self.viewModel.newMessagesCount
                let contentHeight = collectionView.contentSize.height
                let offsetY = collectionView.contentOffset.y
                let bottomOffset = contentHeight - offsetY
                
                CATransaction.begin()
                CATransaction.setDisableActions(true)
 
                collectionView.performBatchUpdates({
                    var indexPaths = [IndexPath]()
                    for i in 0..<amount {
                        let index = 0 + i
                        indexPaths.append(IndexPath(item: index, section: section))
                    }
                    if indexPaths.count > 0 {
                        collectionView.insertItems(at: indexPaths)
                    }
                }, completion: { finished in
                    print("completed loading of new stuff, animating")
                    self.mayLoadNextBatch = true
                    collectionView.contentOffset = CGPoint(x: 0, y: collectionView.contentSize.height - bottomOffset)
                    CATransaction.commit()
                })
                
            }
            self.ignoreFirstWillDisplay = false
        }
    }
}

