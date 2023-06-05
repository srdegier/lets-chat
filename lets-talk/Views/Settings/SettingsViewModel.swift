//
//  SettingsViewModel.swift
//  lets-talk
//
//  Created by Stefan de Gier on 04/06/2023.
//

import Foundation
import UIKit

class SettingsViewModel {
    
    // MARK: - Properties
    
    // MARK: - Data Source
    private var settings: [Section] {
        return [
            Section(title: "About", options: [
                SettingOption(title: "You", icon: UIImage(systemName: "person")!, iconBackgroundColor: UIColor.systemBlue, viewControllerType: .profileSettings),
                SettingOption(title: "Flora", icon: UIImage(systemName: "face.smiling")!, iconBackgroundColor: UIColor.systemGreen, viewControllerType: .buddySettings),
            ]),
            Section(title: "Chat", options: [
                SettingOption(title: "History", icon: UIImage(systemName: "message")!, iconBackgroundColor: UIColor.systemRed, viewControllerType: .historySettings)
            ])
        ]
    }
    
    public func numberOfSections() -> Int {
        return self.settings.count
    }
    
    public func titleForHeaderSection(_ section: Int) -> String {
        return self.settings[section].title
    }
    
    public func numberOfRowsInSection(_ section: Int) -> Int {
        return self.settings[section].options.count
    }
    
    public func settingOptionForIndexPath(_ indexPath: IndexPath) -> SettingOption? {
        guard indexPath.row < self.settings.count else {
            return nil
        }
        return self.settings[indexPath.section].options[indexPath.row]
    }

}
