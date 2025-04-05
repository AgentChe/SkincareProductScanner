//
//  ProductCategory.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 22.03.2025.
//

import Foundation

struct ProductCategory {
    let name: String
    let image: URL
    let description: String
    
    init(
        name: String,
        image: URL,
        description: String
    ) {
        self.name = name
        self.image = image
        self.description = description
    }
    
    init?(json: [String: Any]) {
        guard
            let name = json["name"] as? String,
            let image: URL = {
                guard let path = json["image"] as? String else { return nil }
                return URL(string: path)
            }(),
            let description = json["description"] as? String
        else { return nil }
        
        self.name = name
        self.image = image
        self.description = description
    }
}
