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
