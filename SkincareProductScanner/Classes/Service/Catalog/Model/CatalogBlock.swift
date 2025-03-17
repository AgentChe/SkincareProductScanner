//
//  CatalogBlock.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 17.03.2025.
//

import Foundation

struct CatalogBlock: Codable, Hashable {
    enum Value: Codable, Hashable {
        case text(String)
        case image(URL)
    }
    
    let title: String?
    let value: Value
}

// MARK: Public
extension CatalogBlock {
    init?(json: [String: Any]) {
        guard
            let text = json["text"] as? String,
            let type = json["type"] as? Int
        else { return nil }
        
        var value: Value
        switch type {
        case 1:
            value = .text(text)
        case 2:
            guard let url = URL(string: text) else { return nil }
            value = .image(url)
        default:
            return nil
        }
        
        self.title = json["title"] as? String
        self.value = value
    }
}
