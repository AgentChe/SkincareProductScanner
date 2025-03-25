//
//  PageInfo.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

struct PageInfo {
    let current: Int
    let total: Int
}

// MARK: Public
extension PageInfo {
    init?(json: [String: Any]) {
        guard
            let current = json["current"] as? Int,
            let total = json["total"] as? Int
        else { return nil }
        
        self.current = current
        self.total = total
    }
}
