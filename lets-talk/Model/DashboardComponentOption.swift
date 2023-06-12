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
    
    init(title: String, viewControllerType: ViewControllerType) {
        self.title = title
        self.viewControllerType = viewControllerType
    }
}
