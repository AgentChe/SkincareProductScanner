//
//  OProfileCollector.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 27.01.2025.
//

import Foundation

final class OProfileCollector {
    private var name: String?
}

// MARK: Public
extension OProfileCollector {
    func setup(name: String?) {
        self.name = name
    }
    
    func make() -> Profile {
        Profile(
            
        )
    }
}
