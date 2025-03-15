//
//  ChatManager.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

import RxSwift

protocol ChatManagerProtocol {
    func createChat() -> Single<String?>
    func send(image: UIImage?, message: String, chatId: String) -> Single<SendMessageResponse?>
    func checkMessageComplete(chatId: String, runnerId: String) -> Single<CheckMessageCompleteResponse?>
    func messagesPage(chatId: String, page: Int) -> Single<ChatMessagesPage?>
    func chats() -> Single<[Chat]>
    func deleteChat(id: String) -> Single<Void>
}

final class ChatManager {
    private lazy var sessionManager = SessionManager()
    
    private lazy var restAPITransport = RestAPITransport()
}

// MARK: ChatManagerProtocol
extension ChatManager: ChatManagerProtocol {
    func createChat() -> Single<String?> {
        let anonymousId = sessionManager.anonymousId
        let internalId = sessionManager.internalId
        
        let request = CreateChatRequest(
            anonymousId: anonymousId,
            internalId: (internalId == anonymousId) ? nil : internalId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { CreateChatResponse.map(response: $0) }
    }
    
    func send(image: UIImage?, message: String, chatId: String) -> Single<SendMessageResponse?> {
        let anonymousId = sessionManager.anonymousId
        let internalId = sessionManager.internalId
        
        return restAPITransport
            .sendMessage(
                anonymousId: anonymousId,
                internalId: internalId,
                chatId: chatId,
                image: image,
                message: message
            )
            .map { SendMessageResponse(response: $0) }
    }
    
    func checkMessageComplete(chatId: String, runnerId: String) -> Single<CheckMessageCompleteResponse?> {
        let anonymousId = sessionManager.anonymousId
        let internalId = sessionManager.internalId
        
        let request = CheckMessageCompleteRequest(
            anonymousId: anonymousId,
            internalId: (internalId == anonymousId) ? nil : internalId,
            chatId: chatId,
            runnerId: runnerId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { CheckMessageCompleteResponse(response: $0) }
    }
    
    func messagesPage(chatId: String, page: Int) -> Single<ChatMessagesPage?> {
        let anonymousId = sessionManager.anonymousId
        let internalId = sessionManager.internalId
        
        let request = GetMessagesRequest(
            anonymousId: anonymousId,
            internalId: (internalId == anonymousId) ? nil : internalId,
            chatId: chatId,
            page: page
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { ChatMessagesPage(response: $0, chatId: chatId) }
    }
    
    func chats() -> Single<[Chat]> {
        let anonymousId = sessionManager.anonymousId
        let internalId = sessionManager.internalId
        
        let request = GetChatsRequest(
            anonymousId: anonymousId,
            internalId: (internalId == anonymousId) ? nil : internalId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { Chat.map(response: $0) }
    }
    
    func deleteChat(id: String) -> Single<Void> {
        let anonymousId = sessionManager.anonymousId
        let internalId = sessionManager.internalId
        
        let request = DeleteChatRequest(
            anonymousId: anonymousId,
            internalId: (internalId == anonymousId) ? nil : internalId,
            chatId: id
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
}
