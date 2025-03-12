//
//  SetProfileRequest.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 25.01.2025.
//

import Alamofire

// TODO
struct SetProfileRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let skinTypesIds: [String]?
    let goalsIds: [String]?
    let preferencesIds: [String]?
    
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
        let attrs: [String: Any] = [
            "skin_types": skinTypesIds ?? NSNull(),
            "goals": goalsIds ?? NSNull(),
            "preferences": preferencesIds ?? NSNull()
        ]
        
        return [
            "anonymous_id": anonymousId,
            "internal_id": internalId,
            "attrs": attrs
        ]
    }
}
