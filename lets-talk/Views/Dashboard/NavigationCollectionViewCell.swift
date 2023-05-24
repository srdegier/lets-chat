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
    
}

