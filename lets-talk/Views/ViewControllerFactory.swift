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
    
    var viewController: UIViewController? {
        switch self {
        case .chat:
            return ViewControllerFactory.chatViewController()
        case .solutions:
            return ViewControllerFactory.solutionsViewController()
        case .settings:
            return ViewControllerFactory.settingsViewController()
        }
    }
}

class ViewControllerFactory {
    
    private static let chatStoryboard = UIStoryboard(name: "Chat", bundle: nil)
    private static let solutionsStoryboard = UIStoryboard(name: "Solution", bundle: nil)
    private static let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)

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
    
    internal static func settingsViewController() -> SettingsViewController? {
        let identifier = "SettingsViewController"
        guard let vc = self.settingsStoryboard.instantiateViewController(withIdentifier: identifier) as? SettingsViewController else {
            assertionFailure("Storyboard ID '\(identifier)' not found or incorrect")
            return nil
        }
        return vc
    }
}
