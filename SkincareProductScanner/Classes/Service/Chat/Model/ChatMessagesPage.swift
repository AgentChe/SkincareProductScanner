//
//  ChatMessagesPage.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

struct ChatMessagesPage {
    let messages: [ChatMessage]
    let page: Page
}

// MARK: Public
extension ChatMessagesPage {
    init?(response: Any, chatId: String) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let messagesArray = body["messages"] as? [[String: Any]],
            let pageJSON = body["pagination"] as? [String: Any],
            let page = Page(json: pageJSON)
        else { return nil }
        
        self.messages = messagesArray.compactMap { ChatMessage(chatId: chatId, json: $0) }
        self.page = page
    }
}
