//
//  ProfileViewModel.swift
//  lets-talk
//
//  Created by Stefan de Gier on 11/06/2023.
//

import Foundation

class ProfileViewModel {
    let profileRepository = ProfileRepository()

    // MARK: - Properties
    public var profile: Profile?
    
    // MARK: - Computed Properties
    
    init() {
        getProfile()
    }
    
    // MARK: - Methods
    
    public func validateFields() -> [String: String] {
        var errorMessages: [String: String] = [:]
        if let name = self.profile?.name, name.isEmpty {
            errorMessages["name"] = "Name field is required"
        }
        if (self.profile?.age) == nil {
            errorMessages["age"] = "Age field is required"
        }

        return errorMessages
    }
    
    public func getProfile() -> Void {
        let result = self.profileRepository.getProfile()
        switch result {
        case .success(let profile):
            self.profile = profile
        case .failure(let error):
            self.profile = Profile(name: "Unknown", age: 1)
            print("Unable to get buddy \(error)")
        }
    }
    
    public func saveProfile() {
        if let profile = self.profile {
            let result = self.profileRepository.updateProfile(profile: profile)
            switch result {
            case .success(let buddy):
                // hier evenuteel returnen dat het succesvol is opgeslagen
                print(buddy)
            case .failure(let error):
                //hier eventueel returnen dat het opslaan is mislukt
                print("Unable to update profile \(error)")
            }
        } else {
            // self.profile is nil
        }
    }
}
