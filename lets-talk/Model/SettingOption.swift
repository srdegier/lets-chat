//
//  Setting.swift
//  lets-talk
//
//  Created by Stefan de Gier on 04/06/2023.
//

import Foundation
import UIKit

struct SettingOption {
    let title: String
    let icon: UIImage
    let iconBackgroundColor: UIColor
    let viewControllerType: ViewControllerType
    
    init(title: String, icon: UIImage, iconBackgroundColor: UIColor, viewControllerType: ViewControllerType) {
        self.title = title
        self.icon = icon
        self.iconBackgroundColor = iconBackgroundColor
        self.viewControllerType = viewControllerType
    }
}
