//
//  CatalogDetails.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 17.03.2025.
//

struct CatalogDetails: Codable, Hashable {
    let id: String
    let name: String
    let saved: Bool
    let sections: [CatalogSection]
}

// MARK: Public
extension CatalogDetails {
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let id: String = {
                guard let int = data["id"] as? Int else { return nil }
                return String(int)
            }(),
            let name = data["name"] as? String,
            let saved = data["saved"] as? Bool,
            let sectionsArray = data["sections"] as? [[String: Any]]
        else { return nil }
        
        self.id = id
        self.name = name
        self.saved = saved
        self.sections = sectionsArray.compactMap { CatalogSection(json: $0) }
    }
}
