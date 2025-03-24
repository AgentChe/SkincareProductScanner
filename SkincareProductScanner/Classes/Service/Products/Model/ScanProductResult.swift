//
//  ScanProductResult.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 24.03.2025.
//

struct ScanProductResult {
    let products: [Product]?
    let error: Error?
    
    init(response: Any) {
        guard let json = response as? [String: Any] else {
            self.products = nil
            self.error = ContentError(.notContent)
            
            return
        }
        
        products = {
            guard let body = json["body"] as? [[String: Any]] else { return nil }
            return body.compactMap { Product(json: $0) }
        }()
        
        error = {
            guard let error = json["error"] as? [String: Any] else { return nil }
            
            guard let message = error["message"] as? String else {
                return ContentError(.notContent)
            }
            
            return NetworkError(.logical(message))
        }()
    }
}
