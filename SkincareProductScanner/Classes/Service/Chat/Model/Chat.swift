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
    static func map(response: Any) -> Page<[Chat]>? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let chatsArray = body["items"] as? [[String: Any]],
            let pageJSON = body["pagination"] as? [String: Any],
            let pageInfo = PageInfo(json: pageJSON)
        else { return nil }
        
        let chats = chatsArray.compactMap { Chat(json: $0) }
        
        return Page(info: pageInfo, elements: chats)
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["thread_id"] as? String,
            let created = json["created_timestamp"] as? TimeInterval,
            let messageJSON = json["message"] as? [String: Any],
            let message = ChatMessage(chatId: id, json: messageJSON)
        else { return nil }
        
        self.id = id
        self.created = Date(timeIntervalSince1970: created)
        self.lastMessage = message
    }
}
