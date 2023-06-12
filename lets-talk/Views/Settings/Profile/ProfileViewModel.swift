//
//  ProfileViewModel.swift
//  lets-talk
//
//  Created by Stefan de Gier on 11/06/2023.
//

import Foundation

class ProfileViewModel {
//    let profileRepository = ProfileRepository()

    // MARK: - Properties
    public var profile: Profile?
    
    // MARK: - Computed Properties
    
    // MARK: - Methods
    
    public func validateFields() -> [String: String] {
        var errorMessages: [String: String] = [:]
        if (self.profile?.name) == nil {
            print("error")
            errorMessages["name"] = "Name field is required"
        }
        if (self.profile?.age) == nil {
            print("error")
            errorMessages["age"] = "Age field is required"
        }

        return errorMessages
    }
}
