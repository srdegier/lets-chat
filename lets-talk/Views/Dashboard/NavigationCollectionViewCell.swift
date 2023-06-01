//
//  DashboardCollectionViewCell.swift
//  lets-talk
//
//  Created by Stefan de Gier on 23/04/2023.
//

import Foundation
import UIKit

class NavigationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var navigationViewCell: UIView!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.navigationViewCell.layer.cornerRadius = 10
        self.navigationViewCell.layer.masksToBounds = true
    }
         
     private func setupGestureRecognizer() {
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
         addGestureRecognizer(tapGesture)
     }
     
     @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
         isHighlighted = true
         
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
             self.isHighlighted = false
         }
         
         // Voer hier de verdere acties uit die je wilt doen wanneer de cel wordt aangeraakt
     }
     
     override var isHighlighted: Bool {
         didSet {
             updateCellAppearance()
         }
     }
     
     private func updateCellAppearance() {
         self.navigationViewCell.backgroundColor = isHighlighted ? .secondarySystemFill : .secondarySystemBackground
     }
}

