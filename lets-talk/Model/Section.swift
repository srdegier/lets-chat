//
//  Section.swift
//  lets-talk
//
//  Created by Stefan de Gier on 05/06/2023.
//

import Foundation
import UIKit

struct Section {
    let title: String
    let options: [SettingOption]
    
    init(title: String, options: [SettingOption]) {
        self.title = title
        self.options = options
    }
}
