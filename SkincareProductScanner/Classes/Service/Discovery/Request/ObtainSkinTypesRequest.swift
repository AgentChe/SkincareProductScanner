//
//  ObtainSkinTypesRequest.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 11.03.2025.
//

import Alamofire

struct ObtainSkinTypesRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/catalog/discovery/skin_types"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: HTTPHeaders? {
        [
            "Access-Token": GlobalDefinitions.apiKey
        ]
    }
    
    var parameters: Parameters? {
        [
            "anonymous_id": anonymousId,
            "internal_id": internalId
        ]
    }
}
