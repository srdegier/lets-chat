//
//  SettingsViewModel.swift
//  lets-talk
//
//  Created by Stefan de Gier on 04/06/2023.
//

import Foundation
import UIKit

class SettingsViewModel {
    
    let buddyRepository = BuddyRepository()

    // MARK: - Properties
    var buddyName: String?
    
    // MARK: - Data Source
    private var settings: [Section] {
        return [
            Section(title: "About", options: [
                SettingOption(title: "You", icon: UIImage(systemName: "person")!, iconBackgroundColor: UIColor.systemBlue, viewControllerType: .profileSettings),
                SettingOption(title: self.buddyName ?? "Unknown", icon: UIImage(systemName: "face.smiling")!, iconBackgroundColor: UIColor.systemGreen, viewControllerType: .buddySettings),
            ]),
            Section(title: "Chat", options: [
                SettingOption(title: "History", icon: UIImage(systemName: "message")!, iconBackgroundColor: UIColor.systemRed, viewControllerType: .historySettings)
            ])
        ]
    }
    
    //MARK: Methods
    
    public func getBuddyName() -> Void {
        let result = self.buddyRepository.getName()
        switch result {
        case .success(let name):
            self.buddyName = name
        case .failure(let error):
            print("Unable to get buddy \(error)")
            self.buddyName = "Unknown"
        }
    }
    
    //MARK: Tableview
    
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
