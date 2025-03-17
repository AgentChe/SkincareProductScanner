//
//  CatalogSection.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 17.03.2025.
//

struct CatalogSection: Codable, Hashable {
    let name: String
    let blocks: [CatalogBlock]
}

// MARK: Public
extension CatalogSection {
    init?(json: [String: Any]) {
        guard
            let name = json["name"] as? String,
            let blocksArray = json["blocks"] as? [[String: Any]]
        else { return nil }
        
        self.name = name
        self.blocks = blocksArray.compactMap { CatalogBlock(json: $0) }
    }
}
