//
//  CheckMessageCompleteRequest.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

import Alamofire

struct CheckMessageCompleteRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String?
    let chatId: String
    let runnerId: String
    
    // TODO: https://skin.thinkaboutapps.com -> GlobalDefinitions.domain
    var url: String {
        "https://skin.thinkaboutapps.com" + "/api/v1/ai/chat/runner"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    // TODO: K9tK6iIQ4mZZNnWhs9c9y3DI -> GlobalDefinitions.apiKey
    var headers: HTTPHeaders? {
        [
            "Access-Token": "K9tK6iIQ4mZZNnWhs9c9y3DI"
        ]
    }
    
    var parameters: Parameters? {
        var params: Parameters = [
            "anonymous_id": anonymousId,
            "thread_id": chatId,
            "run_id": runnerId
        ]
        
        if let internalId {
            params["internal_id"] = internalId
        }
        
        return params
    }
}
