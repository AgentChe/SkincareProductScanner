//
//  ChatMessage.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

import Foundation

struct ChatMessage {
    enum Role: String {
        case user = "user"
        case assistant = "assistant"
    }
    
    let chatId: String
    let messageId: String
    let role: Role
    let content: String
    let imageUrl: URL?
    let created: Date
}

// MARK: Public
extension ChatMessage {
    static func map(response: Any, chatId: String) -> Page<[ChatMessage]>? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let messagesArray = body["items"] as? [[String: Any]],
            let pageJSON = body["pagination"] as? [String: Any],
            let pageInfo = PageInfo(json: pageJSON)
        else { return nil }
        
        let messages = messagesArray.compactMap { ChatMessage(chatId: chatId, json: $0) }
        
        return Page(info: pageInfo, elements: messages)
    }
    
    init?(json: [String: Any]) {
        guard
            let chatId = json["thread_id"] as? String,
            let messageId = json["message_id"] as? String,
            let roleRawValue = json["role"] as? String,
            let role = Role(rawValue: roleRawValue),
            let content = json["content"] as? String,
            let created = json["created_timestamp"] as? TimeInterval
        else { return nil }
        
        self.chatId = chatId
        self.messageId = messageId
        self.role = role
        self.content = content
        self.imageUrl = {
            guard let path = json["image"] as? String else { return nil }
            return URL(string: path)
        }()
        self.created = Date(timeIntervalSince1970: created)
    }
    
    init?(chatId: String, json: [String: Any]) {
        guard
            let messageId = json["message_id"] as? String,
            let roleRawValue = json["role"] as? String,
            let role = Role(rawValue: roleRawValue),
            let content = json["content"] as? String,
            let created = json["created_timestamp"] as? TimeInterval
        else { return nil }
        
        self.chatId = chatId
        self.messageId = messageId
        self.role = role
        self.content = content
        self.imageUrl = {
            guard let path = json["image"] as? String else { return nil }
            return URL(string: path)
        }()
        self.created = Date(timeIntervalSince1970: created)
    }
}
