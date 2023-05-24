//
//  ChatDataSource.swift
//  lets-talk
//
//  Created by Stefan de Gier on 21/05/2023.
//

import Foundation
import UIKit

class ChatDataSource: NSObject, ChatDataSourceProtocol, UICollectionViewDelegate {

    internal let viewModel: ChatViewModel
    
    required init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let chatMessage = self.viewModel.messages[indexPath.item].message
        let messageType = self.viewModel.messages[indexPath.item].type
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: messageType.rawValue, for: indexPath) as? ChatCollectionViewCell else {
            fatalError("Unable to dequeue ChatCollectionViewCell")
        }

        cell.configure(with: chatMessage, isChatMode: true, messageType: messageType)
        return cell
    }
}
