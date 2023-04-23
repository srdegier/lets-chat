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
    
    let dashboardComponentTypes: [DashboardComponentType]

    // MARK: - Initialization

    init(dashboardComponentTypes: [DashboardComponentType]) {
       self.dashboardComponentTypes = dashboardComponentTypes
    }
       

    
    // MARK: - Data Source
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        print(dashboardComponentTypes.count)
        return dashboardComponentTypes.count
    }
    
    func titleForIndexPath(_ indexPath: IndexPath) -> String? {
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
    
    func messageComponentTypeForIndexPath(_ indexPath: IndexPath) -> DashboardComponentType? {
        guard indexPath.row < dashboardComponentTypes.count else {
            return nil
        }
        
        return dashboardComponentTypes[indexPath.row]
    }
    
//    func someViewModel() -> SomeViewModel? {
//        return SomeViewModel()
//    }

}
