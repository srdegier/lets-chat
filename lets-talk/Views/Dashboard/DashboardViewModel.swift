//
//  DashboardViewModel.swift
//  lets-talk
//
//  Created by Stefan de Gier on 21/04/2023.
//

import Foundation

class DashboardViewModel {
    
    let profileRepository = ProfileRepository()
    
    // MARK: - Properties
    private var profileName: String?
    
    // MARK: - Computed Properties
    public var avatarMessage: String {
        let timeOfDay = getTimeOfDay()
        return "Good \(timeOfDay) \(self.profileName ?? "Unknown")!"
    }

    private lazy var currentTime: Date = {
        return Date()
    }()

    private lazy var currentCalendar: Calendar = {
        return Calendar.current
    }()

    private func getTimeOfDay() -> String {
        let hour = currentCalendar.component(.hour, from: currentTime)

        if hour < 12 {
            return "morning"
        } else if hour < 17 {
            return "afternoon"
        } else {
            return "evening"
        }
    }
    
    // MARK: - Data Source
    private var dashboardComponentOptions: [DashboardComponentOption] {
        return [
            DashboardComponentOption(title: "Chat", viewControllerType: .chat, imageSource: "typing-2", contentMode: .scaleAspectFit),
            DashboardComponentOption(title: "Settings", viewControllerType: .settings, imageSource: "settings", contentMode: .scaleAspectFit)
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
    
    //MARK: Methods
    
    public func getProfileName() -> Void {
        let result = self.profileRepository.getName()
        switch result {
        case .success(let name):
            self.profileName = name
        case .failure(let error):
            print("Unable to get buddy \(error)")
            self.profileName = "Unknown"
        }
    }

}
