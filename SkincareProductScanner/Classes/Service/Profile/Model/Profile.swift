//
//  Profile.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 24.01.2025.
//

import Foundation

struct Profile {
    let skinTypesIds: [String]?
    let goalsIds: [String]?
    let preferencesIds: [String]?
}

// MARK: Public
extension Profile {
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any]
        else { return nil }
        
        self.skinTypesIds = body["skin_types"] as? [String]
        self.goalsIds = body["goals"] as? [String]
        self.preferencesIds = body["preferences"] as? [String]
    }
}
