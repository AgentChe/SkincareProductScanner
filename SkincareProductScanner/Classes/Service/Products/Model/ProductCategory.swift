//
//  ProductCategory.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 22.03.2025.
//

import Foundation

struct ProductCategory {
    let id: String
    let name: String
    let image: URL
    let description: String
}

// MARK: Public
extension ProductCategory {
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String,
            let image: URL = {
                guard let path = json["image"] as? String else { return nil }
                return URL(string: path)
            }(),
            let description = json["description"] as? String
        else { return nil }
        
        self.id = id
        self.name = name
        self.image = image
        self.description = description
    }
}
