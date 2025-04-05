//
//  ObtainGoalsRequest.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 11.03.2025.
//

import Alamofire

struct ObtainGoalsRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/catalog/discovery/goals"
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
    
    var encoding: ParameterEncoding {
        URLEncoding.queryString
    }
}
