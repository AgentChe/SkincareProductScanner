//
//  GetProductsRequest.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 24.03.2025.
//

import Alamofire

struct GetProductsRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let search: String?
    let presets: String?
    let filters: [String: [String]]?
    let page: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/catalog/search"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var filter: Parameters = [:]
        if let presets {
            filter["presets"] = presets
        }
        if let filters {
            filters.forEach { key, values in
                filter[key] = values
            }
        }
        
        return [
            "anonymous_id": anonymousId,
            "internal_id": internalId,
            "search": search ?? NSNull(),
            "filter": filter,
            "page": page
        ]
    }
    
    var headers: HTTPHeaders? {
        [
            "Access-Token": GlobalDefinitions.apiKey
        ]
    }
}
