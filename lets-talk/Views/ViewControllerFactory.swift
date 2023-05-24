//
//  ViewControllerFactory.swift
//  lets-talk
//
//  Created by Stefan de Gier on 21/04/2023.
//

import Foundation
import UIKit

class ViewControllerFactory {
    
    private static let chatStoryboard = UIStoryboard(name: "Chat", bundle: nil)
    private static let solutionsStoryboard = UIStoryboard(name: "Solution", bundle: nil)

    
    internal static func chatViewController() -> UIViewController {
        let vc = self.chatStoryboard.instantiateViewController(withIdentifier: "ChatViewController")
        return vc
    }
    
    internal static func solutionsViewController() -> UIViewController {
        let vc = self.solutionsStoryboard.instantiateViewController(withIdentifier: "SolutionViewController")
        return vc
    }
}
