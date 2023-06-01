//
//  DashboardViewModel.swift
//  lets-talk
//
//  Created by Stefan de Gier on 21/04/2023.
//

import Foundation

enum DashboardComponentType {
    case chat
    case solutions
}

class DashboardViewModel {
    
    // MARK: - Properties
    
    public let dashboardComponentTypes: [DashboardComponentType]
    
    public var avatarMessage: String {
        return "Good evening Stefan!"
    }

    // MARK: - Initialization

    init(dashboardComponentTypes: [DashboardComponentType]) {
       self.dashboardComponentTypes = dashboardComponentTypes
    }
       
    
    // MARK: - Data Source
    
    public func numberOfSections() -> Int {
        return 1
    }
    
    public func numberOfRowsInSection(_ section: Int) -> Int {
        return dashboardComponentTypes.count
    }
    
    public func titleForIndexPath(_ indexPath: IndexPath) -> String? {
        guard indexPath.row < dashboardComponentTypes.count else {
            return nil
        }
        switch dashboardComponentTypes[indexPath.row] {
        case .chat:
            return "Chat 💬"
        case .solutions:
            return "Solutions 💡"
        }
    }
    
    public func messageComponentTypeForIndexPath(_ indexPath: IndexPath) -> DashboardComponentType? {
        guard indexPath.row < dashboardComponentTypes.count else {
            return nil
        }
        
        return dashboardComponentTypes[indexPath.row]
    }
    
//    func someViewModel() -> SomeViewModel? {
//        return SomeViewModel()
//    }

}
