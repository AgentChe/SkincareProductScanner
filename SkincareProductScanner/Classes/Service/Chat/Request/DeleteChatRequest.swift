//
//  DeleteChatRequest.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

import Alamofire

struct DeleteChatRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String?
    let chatId: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/ai/chat/delete"
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
            "thread_id": chatId
        ]
        
        if let internalId {
            params["internal_id"] = internalId
        }
        
        return params
    }
}
