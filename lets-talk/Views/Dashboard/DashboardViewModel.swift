//
//  DashboardViewModel.swift
//  lets-talk
//
//  Created by Stefan de Gier on 21/04/2023.
//

import Foundation

class DashboardViewModel {
    
    // MARK: - Properties
    public var avatarMessage: String {
        return "Good evening Stefan!"
    }
    
    // MARK: - Data Source
    private var dashboardComponentOptions: [DashboardComponentOption] {
        return [
            DashboardComponentOption(title: "Chat 💬", viewControllerType: .chat),
            DashboardComponentOption(title: "Solutions 💡", viewControllerType: .solutions)
        ]
    }
    
    public func numberOfSections() -> Int {
        return 1
    }
    
    public func numberOfRowsInSection(_ section: Int) -> Int {
        return self.dashboardComponentOptions.count
    }
    
    public func dashboardComponentOptionForIndexPath(_ indexPath: IndexPath) -> DashboardComponentOption? {
        guard indexPath.row < dashboardComponentOptions.count else {
            return nil
        }
        return self.dashboardComponentOptions[indexPath.row]
    }

}
