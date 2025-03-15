//
//  CreateChatResponse.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

enum CreateChatResponse {
    static func map(response: Any) -> String? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any]
        else { return nil }
        
        return body["thread_id"] as? String
    }
}
