//
//  ObtainGoalsRequest.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 11.03.2025.
//

import Alamofire

// TODO
struct ObtainGoalsRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    
    var url: String {
        GlobalDefinitions.domain + "/backend/v1/profile/get"
    }
    
    var method: HTTPMethod {
        .post
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
