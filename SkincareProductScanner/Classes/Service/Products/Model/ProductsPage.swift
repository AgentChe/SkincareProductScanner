//
//  ProductsPage.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 24.03.2025.
//

struct ProductsPage {
    let products: [Product]
    let page: Page
    
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let array = body["items"] as? [[String: Any]],
            let paginationJSON = body["pagination"] as? [String: Any],
            let page = Page(json: paginationJSON)
        else { return nil }
        
        self.products = array.compactMap { Product(json: $0) }
        self.page = page
    }
}
