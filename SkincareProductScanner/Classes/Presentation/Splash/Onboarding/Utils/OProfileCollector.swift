//
//  OProfileCollector.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 27.01.2025.
//

import Foundation

final class OProfileCollector {
    private var skinTypesIds: [String]?
    private var goalsIds: [String]?
    private var preferencesIds: [String]?
}

// MARK: Public
extension OProfileCollector {
    func setup(skinTypesIds: [String]?) {
        self.skinTypesIds = skinTypesIds
    }
    
    func setup(goalsIds: [String]?) {
        self.goalsIds = goalsIds
    }
    
    func setup(preferencesIds: [String]?) {
        self.preferencesIds = preferencesIds
    }
    
    func make() -> Profile {
        Profile(
            skinTypesIds: skinTypesIds,
            goalsIds: goalsIds,
            preferencesIds: preferencesIds
        )
    }
}
