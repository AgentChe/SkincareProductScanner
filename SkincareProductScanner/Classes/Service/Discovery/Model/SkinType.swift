//
//  SkinType.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 11.03.2025.
//

struct SkinType: Codable {
    let id: String
    let name: String
}

// MARK: Public
extension SkinType {
    static func map(response: Any) -> [SkinType]? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [[String: Any]]
        else { return nil }
        
        return body.compactMap { SkinType(json: $0) }
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String
        else { return nil }
        
        self.id = id
        self.name = name
    }
}
