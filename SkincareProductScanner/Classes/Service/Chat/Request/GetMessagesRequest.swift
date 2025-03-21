//
//  GetMessagesRequest.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

import Alamofire

struct GetMessagesRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String?
    let chatId: String
    let page: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/ai/chat/messages"
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
            "page": page
        ]
        
        if let internalId {
            params["internal_id"] = internalId
        }
        
        return params
    }
}
