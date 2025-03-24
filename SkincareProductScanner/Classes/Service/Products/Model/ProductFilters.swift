//
//  ProductFilters.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 24.03.2025.
//

import Foundation

struct ProductFilters: Codable {
    let presets: [ProductPresetFilter]
    let filters: [ProductFilter]
    
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any]
        else { return nil }
        
        presets = {
            guard let array = body["presets"] as? [[String: Any]] else { return [] }
            return array.compactMap { ProductPresetFilter(json: $0) }
        }()
        filters = {
            guard let array = body["filters"] as? [[String: Any]] else { return [] }
            return array.compactMap { ProductFilter(json: $0) }
        }()
    }
}

struct ProductPresetFilter: Codable {
    let name: String
    let image: URL
    let items: [String]
    
    init?(json: [String: Any]) {
        guard
            let name = json["name"] as? String,
            let image: URL = {
                guard let string = json["image"] as? String else { return nil }
                return URL(string: string)
            }(),
            let items = json["items"] as? [String]
        else { return nil }
        
        self.name = name
        self.image = image
        self.items = items
    }
}

struct ProductFilter: Codable {
    let id: String
    let name: String
    let items: [ProductFilterItem]
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String,
            let array = json["items"] as? [[String: Any]]
        else { return nil }
        
        self.id = id
        self.name = name
        self.items = array.compactMap { ProductFilterItem(json: $0) }
    }
}

struct ProductFilterItem: Codable {
    let id: String
    let name: String
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String
        else { return nil }
        
        self.id = id
        self.name = name
    }
}
