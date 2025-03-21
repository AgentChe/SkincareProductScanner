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
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/ai/chat/runner"
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
