//
//  Profile.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 24.01.2025.
//

import Foundation

// TODO
struct Profile {
    
}

// MARK: Public
extension Profile {
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any]
        else { return nil }
        
        
    }
}
