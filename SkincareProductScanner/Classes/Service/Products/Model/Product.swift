//
//  Product.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 22.03.2025.
//

import Foundation

struct Product {
    let id: String
    let title: String
    let image: URL
    let brand: String
}

// MARK: Public
extension Product {
    static func map(response: Any) -> Page<[Product]>? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let array = body["items"] as? [[String: Any]],
            let paginationJSON = body["pagination"] as? [String: Any],
            let pageInfo = PageInfo(json: paginationJSON)
        else { return nil }
        
        let products = array.compactMap { Product(json: $0) }
        
        return Page(info: pageInfo, elements: products)
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let title = json["title"] as? String,
            let image: URL = {
                guard let path = json["image"] as? String else { return nil }
                return URL(string: path)
            }(),
            let brand = json["brand"] as? String
        else { return nil }
        
        self.id = id
        self.title = title
        self.image = image
        self.brand = brand
    }
}
