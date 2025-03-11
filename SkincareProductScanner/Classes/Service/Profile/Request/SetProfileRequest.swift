//
//  SetProfileRequest.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 25.01.2025.
//

import Alamofire

struct SetProfileRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    
    var url: String {
        GlobalDefinitions.domain + "/backend/v1/profile/update"
    }
    
    var method: HTTPMethod {
        .put
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
