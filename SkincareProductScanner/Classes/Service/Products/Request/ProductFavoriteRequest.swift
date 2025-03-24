//
//  ProductFavoriteRequest.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 24.03.2025.
//

import Alamofire

struct ProductFavoriteRequest: APIRequestBody {
    enum Action {
        case add, remove
    }
    
    let anonymousId: String
    let internalId: String
    let id: String
    let action: Action
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/catalog/favorite"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "anonymous_id": anonymousId,
            "internal_id": internalId,
            "product": id,
            "remove": {
                switch action {
                case .add:
                    return false
                case .remove:
                    return true
                }
            }()
        ]
    }
    
    var headers: HTTPHeaders? {
        [
            "Access-Token": GlobalDefinitions.apiKey
        ]
    }
}
