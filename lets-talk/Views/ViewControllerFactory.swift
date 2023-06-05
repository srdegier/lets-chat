//
//  ViewControllerFactory.swift
//  lets-talk
//
//  Created by Stefan de Gier on 21/04/2023.
//

import Foundation
import UIKit

enum ViewControllerType {
    case chat
    case solutions
    case settings
    case buddySettings
    case profileSettings
    case historySettings
    
    var viewController: UIViewController? {
        switch self {
        case .chat:
            return ViewControllerFactory.chatViewController()
        case .solutions:
            return ViewControllerFactory.solutionsViewController()
        case .settings:
            return ViewControllerFactory.settingsViewController()
        case .buddySettings:
            return ViewControllerFactory.buddySettingsViewController()
        case .profileSettings:
            return ViewControllerFactory.profileSettingsViewController()
        case .historySettings:
            return ViewControllerFactory.historySettingsViewController()
        }
    }
}

class ViewControllerFactory {
    
    private static let chatStoryboard = UIStoryboard(name: "Chat", bundle: nil)
    private static let solutionsStoryboard = UIStoryboard(name: "Solution", bundle: nil)
    
    private static let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)
    private static let buddySettingsStoryboard = UIStoryboard(name: "BuddySettings", bundle: nil)
    private static let profileSettingsStoryboard = UIStoryboard(name: "ProfileSettings", bundle: nil)
    private static let historySettingsStoryboard = UIStoryboard(name: "HistorySettings", bundle: nil)

    internal static func chatViewController() -> ChatViewController? {
        let identifier = "ChatViewController"
        guard let vc = self.chatStoryboard.instantiateViewController(withIdentifier: identifier) as? ChatViewController else {
            assertionFailure("Storyboard ID '\(identifier)' not found or incorrect")
            return nil
        }
        return vc
    }
    
    internal static func solutionsViewController() -> SolutionViewController? {
        let identifier = "SolutionViewController"
        guard let vc = self.solutionsStoryboard.instantiateViewController(withIdentifier: identifier) as? SolutionViewController else {
            assertionFailure("Storyboard ID '\(identifier)' not found or incorrect")
            return nil
        }
        return vc
    }
    
    // MARK: Settings view
    
    internal static func settingsViewController() -> SettingsViewController? {
        let identifier = "SettingsStoryboard"
        guard let vc = self.settingsStoryboard.instantiateViewController(withIdentifier: identifier) as? SettingsViewController else {
            assertionFailure("Storyboard ID '\(identifier)' not found or incorrect")
            return nil
        }
        return vc
    }
    
    // MARK: Setting Options
    
    internal static func buddySettingsViewController() -> BuddySettingsViewController? {
        let identifier = "BuddySettingsStoryboard"
        guard let vc = self.buddySettingsStoryboard.instantiateViewController(withIdentifier: identifier) as? BuddySettingsViewController else {
            assertionFailure("Storyboard ID '\(identifier)' not found or incorrect")
            return nil
        }
        return vc
    }
    
    internal static func profileSettingsViewController() -> ProfileSettingsViewController? {
        let identifier = "ProfileSettingsStoryboard"
        guard let vc = self.profileSettingsStoryboard.instantiateViewController(withIdentifier: identifier) as? ProfileSettingsViewController else {
            assertionFailure("Storyboard ID '\(identifier)' not found or incorrect")
            return nil
        }
        return vc
    }
    
    internal static func historySettingsViewController() -> HistorySettingsViewController? {
        let identifier = "HistorySettingsStoryboard"
        guard let vc = self.historySettingsStoryboard.instantiateViewController(withIdentifier: identifier) as? HistorySettingsViewController else {
            assertionFailure("Storyboard ID '\(identifier)' not found or incorrect")
            return nil
        }
        return vc
    }
    
}
