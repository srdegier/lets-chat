//
//  ChatDelegateProtocol.swift
//  lets-talk
//
//  Created by Stefan de Gier on 22/05/2023.
//

import Foundation
import UIKit

protocol ChatDelegateProtocol: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var viewModel: ChatViewModel { get }
    init(viewModel: ChatViewModel)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
}
