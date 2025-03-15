//
//  Chat.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

import Foundation

struct Chat {
    let id: String
    let created: Date
    let lastMessage: ChatMessage
}

// MARK: Public
extension Chat {
    static func map(response: Any) -> [Chat] {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [[String: Any]]
        else { return [] }
        
        return body.compactMap { json -> Chat? in
            guard
                let id = json["thread_id"] as? String,
                let created = json["created_timestamp"] as? TimeInterval,
                let messageJSON = json["message"] as? [String: Any],
                let message = ChatMessage(chatId: id, json: messageJSON)
            else { return nil }
            
            return Chat(
                id: id,
                created: Date(timeIntervalSince1970: created),
                lastMessage: message
            )
        }
    }
}
