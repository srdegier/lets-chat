//
//  DashboardCompentType.swift
//  lets-talk
//
//  Created by Stefan de Gier on 04/06/2023.
//

import Foundation
import UIKit

struct DashboardComponentOption {
    let title: String
    let viewControllerType: ViewControllerType
    let imageSource: String
    let contentMode: UIView.ContentMode
    
    init(title: String, viewControllerType: ViewControllerType, imageSource: String, contentMode: UIView.ContentMode) {
        self.title = title
        self.viewControllerType = viewControllerType
        self.imageSource = imageSource
        self.contentMode = contentMode
    }
}
