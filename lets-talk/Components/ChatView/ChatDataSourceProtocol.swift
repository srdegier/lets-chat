//
//  ChatDataSourceProtocol.swift
//  lets-talk
//
//  Created by Stefan de Gier on 21/05/2023.
//

import Foundation
import UIKit

protocol ChatDataSourceProtocol: UICollectionViewDataSource, UICollectionViewDelegate {
    var viewModel: ChatViewModel { get }
    init(viewModel: ChatViewModel)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    // TODO: Force to be return value ChatCollectionViewCell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}
