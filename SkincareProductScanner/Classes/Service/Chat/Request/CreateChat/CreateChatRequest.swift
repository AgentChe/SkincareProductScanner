//
//  CreateChatRequest.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

import Alamofire

struct CreateChatRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String?
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/ai/chat/create"
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
        var params: Parameters = [
            "anonymous_id": anonymousId
        ]
        
        if let internalId {
            params["internalId"] = internalId
        }
        
        return params
    }
}
