//
//  HapticFeedbackManagers.swift
//  lets-talk
//
//  Created by Stefan de Gier on 01/06/2023.
//

import Foundation
import UIKit

class HapticFeedbackManager {
    static let shared = HapticFeedbackManager()
    
    private init() { }
    
    func performSelectionFeedback() {
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.prepare()
        selectionFeedback.selectionChanged()
    }
    
    func performImpactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactFeedback = UIImpactFeedbackGenerator(style: style)
        impactFeedback.prepare()
        impactFeedback.impactOccurred()
    }
    
    func performNotificationFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.prepare()
        notificationFeedback.notificationOccurred(type)
    }
    
    func performHapticFeedback() {
        performSelectionFeedback()
        performImpactFeedback(style: .medium)
        performNotificationFeedback(type: .success)
    }
}
