//
//  Catalog.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 17.03.2025.
//

struct Catalog: Codable, Hashable {
    let id: String
    let name: String
    let saved: Bool
}

// MARK: Public
extension Catalog {
    static func map(response: Any) -> [Catalog] {
        guard
           let json = response as? [String: Any],
           let data = json["_data"] as? [String: Any],
           let drugs = data["drugs"] as? [[String: Any]]
       else { return [] }
            
        return drugs.compactMap { Catalog(json: $0) }
    }
    
    init?(json: [String: Any]) {
        guard
            let id: String = {
                guard let int = json["id"] as? Int else { return nil }
                return String(int)
            }(),
            let name = json["name"] as? String,
            let saved = json["saved"] as? Bool
        else { return nil }
        
        self.id = id
        self.name = name
        self.saved = saved
    }
}
