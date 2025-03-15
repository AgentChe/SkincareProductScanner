//
//  ChatViewModel.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

import RxSwift
import RxCocoa

final class ChatViewModel {
    typealias DataForSendMessage = (UIImage?, String)
    
    enum Route {
        case history
        case disclaimer
        case references
    }
    
    enum DisplayInput {
        case questionInput
        case regenerateLastQuestion
    }
    
    enum Action {
        case reset
        case insertPage([ChatTableElement])
        case add([ChatTableElement])
        case removeAnswer(String)
        case startWaiting
        case stopWaiting
        case changeInput(DisplayInput)
        case clearInput
        case copy(String)
        case lockSendMessage(Bool)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var chatManager = ChatManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension ChatViewModel {
    struct Input {
        let didTapHistory: Signal<Void>
        let didSelectChatFromHistory: Signal<Chat>
        let didStartNewChat: Signal<Void>
        let didScrollToTop: Signal<Void>
        let didSendMessage: Signal<DataForSendMessage>
        let didTapRegenerate: Signal<DataForSendMessage>
        let didTapCopy: Signal<String>
        let didTapRefresh: Signal<ChatTableAnswerElement>
        let didTapDisclaimer: Signal<Void>
        let didTapReferences: Signal<Void>
        let inputFocusChanged: Signal<Bool>
    }
    
    struct Output {
        let route: Driver<Route>
        let action: Driver<Action>
        let disclaimerHidden: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let didStartNewChat = input.didStartNewChat
            .startWith(())
        let mode = makeMode(
            didSelectChatFromHistory: input.didSelectChatFromHistory,
            didStartNewChat: didStartNewChat
        )
        let chatId = makeChatId(mode: mode)
        
        return Output(
            route: makeRoute(
                didTapHistory: input.didTapHistory,
                didTapDisclaimer: input.didTapDisclaimer,
                didTapReferences: input.didTapReferences
            ),
            action: makeAction(
                mode: mode,
                chatId: chatId,
                didSendMessage: input.didSendMessage,
                didTapRegenerate: input.didTapRegenerate,
                didTapCopy: input.didTapCopy,
                didTapRefresh: input.didTapRefresh,
                didScrollToTop: input.didScrollToTop
            ),
            disclaimerHidden: input.inputFocusChanged
                .map { $0 }
                .asDriver(onErrorDriveWith: .never())
        )
    }
}

// MARK: Private
private extension ChatViewModel {
    enum Mode {
        case newChat, history(Chat)
    }
    
    func makeRoute(
        didTapHistory: Signal<Void>,
        didTapDisclaimer: Signal<Void>,
        didTapReferences: Signal<Void>
    ) -> Driver<Route> {
        let history = didTapHistory
            .map { Route.history }
            .asDriver(onErrorDriveWith: .never())
        
        let disclaimer = didTapDisclaimer
            .map { Route.disclaimer }
            .asDriver(onErrorDriveWith: .never())
        
        let references = didTapReferences
            .map { Route.references }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(history, disclaimer, references)
    }
    
    func makeMode(
        didSelectChatFromHistory: Signal<Chat>,
        didStartNewChat: Signal<Void>
    ) -> Driver<Mode> {
        let history = didSelectChatFromHistory
            .map { Mode.history($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let newChat = didStartNewChat
            .map { Mode.newChat }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(history, newChat)
    }
    
    func makeAction(
        mode: Driver<Mode>,
        chatId: Driver<String>,
        didSendMessage: Signal<DataForSendMessage>,
        didTapRegenerate: Signal<DataForSendMessage>,
        didTapCopy: Signal<String>,
        didTapRefresh: Signal<ChatTableAnswerElement>,
        didScrollToTop: Signal<Void>
    ) -> Driver<Action> {
        let reset = mode
            .map { _ in Action.reset }
        
        let clearInput = Driver
            .merge(
                mode.map { _ in Action.clearInput },
                didSendMessage.map { _ in Action.clearInput }.asDriver(onErrorDriveWith: .never())
            )
        
        let copy = didTapCopy
            .map { Action.copy($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let updateChat = mode
            .flatMapLatest { [weak self] _ -> Driver<Action> in
                guard let self else { return .never() }
                
                let sendMessageResponse = makeSendMessageResponse(
                    chatId: chatId,
                    didSendMessage: didSendMessage,
                    didTapRegenerate: didTapRegenerate
                )
                
                let addQuestionInTable = sendMessageResponse
                    .compactMap { response -> Action? in
                        guard let response else { return nil }
                        
                        var elements = [ChatTableElement]()
                        
                        if let imageUrl = response.message.imageUrl {
                            elements.append(.questionImageUrl(imageUrl))
                        }
                        elements.append(.questionText(response.message.content))
                        
                        return .add(elements)
                    }
                
                let answerMessageResponse = makeAnswer(
                    runner: Driver
                        .merge(
                            sendMessageResponse.compactMap { $0?.runner },
                            didTapRefresh.map { $0.runner }.asDriver(onErrorDriveWith: .never())
                        ),
                    chatId: chatId
                )
                
                let addAnswerInTable = answerMessageResponse
                    .compactMap { response -> Action? in
                        guard let response, let message = response.message else { return nil }
                        
                        let element = ChatTableAnswerElement(runner: response.runner, message: message)
                        return .add([.answer(element)])
                    }
                
                let loading = Driver<Bool>
                    .merge(
                        sendMessageResponse.compactMap { $0 == nil ? nil : true },
                        didTapRefresh.map { _ in true }.asDriver(onErrorDriveWith: .never()),
                        answerMessageResponse.map { _ in false }
                    )
                
                let waiting = loading
                    .map { $0 ? Action.startWaiting : Action.stopWaiting }
                
                let lockSendMessage = loading
                    .map { Action.lockSendMessage($0) }
                
                let displayInput = Driver<DisplayInput>
                    .merge(
                        didTapRegenerate
                            .map { _ in .questionInput }
                            .asDriver(onErrorDriveWith: .never()),
                        
                        sendMessageResponse
                            .map { $0 == nil ? .regenerateLastQuestion : .questionInput },
                        
                        answerMessageResponse
                            .map { $0 == nil ? .regenerateLastQuestion : .questionInput }
                    )
                    .startWith(.questionInput)
                    .map { Action.changeInput($0) }
                
                let removeAnswer = didTapRefresh
                    .map { Action.removeAnswer($0.message.messageId) }
                    .asDriver(onErrorDriveWith: .never())
                
                let historyPage = makeHistoryPage(
                    mode: mode,
                    didScrollToTop: didScrollToTop,
                    chatId: chatId
                )
                
                let historyElements = historyPage
                    .map { $0.messages }
                    .map { messages -> [ChatTableElement] in
                        var elements = [ChatTableElement]()
                        
                        messages.reversed().forEach { message in
                            switch message.role {
                            case .user:
                                if let imageUrl = message.imageUrl {
                                    elements.append(.questionImageUrl(imageUrl))
                                }
                                elements.append(.questionText(message.content))
                            case .assistant:
                                elements.append(.historyAnswer(message))
                            }
                        }
                        
                        return elements
                    }
                    .map { Action.insertPage($0) }
                
                return Driver
                    .merge(addQuestionInTable, addAnswerInTable, waiting, lockSendMessage, displayInput, removeAnswer, historyElements)
            }
        
        return Driver
            .merge(reset, clearInput, copy, updateChat)
    }
    
    func makeAnswer(runner: Driver<ChatMessageRunner>, chatId: Driver<String>) -> Driver<CheckMessageCompleteResponse?> {
        runner
            .withLatestFrom(chatId) { ($0.id, $1) }
            .delay(DispatchTimeInterval.seconds(2))
            .flatMapLatest { [weak self] args -> Driver<CheckMessageCompleteResponse?> in
                guard let self else { return .never() }
                
                let (runnerId, id) = args
                
                return chatManager
                    .checkMessageComplete(chatId: id, runnerId: runnerId)
                    .asDriver(onErrorJustReturn: nil)
                    .flatMap { [weak self] response -> Driver<CheckMessageCompleteResponse?> in
                        guard let self, let response else { return .just(nil) }
                        
                        return response.runner.isComplete ? .just(response) : makeAnswer(runner: runner, chatId: chatId)
                    }
            }
    }
    
    func makeSendMessageResponse(
        chatId: Driver<String>,
        didSendMessage: Signal<DataForSendMessage>,
        didTapRegenerate: Signal<DataForSendMessage>
    ) -> Driver<SendMessageResponse?> {
        Signal
            .merge(didSendMessage, didTapRegenerate)
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(chatId) { ($0, $1) }
            .flatMapLatest { [weak self] data, chatId -> Driver<SendMessageResponse?> in
                guard let self else { return .never() }
                
                let (image, message) = data
                
                return chatManager
                    .send(image: image, message: message, chatId: chatId)
                    .asDriver(onErrorJustReturn: nil)
            }
    }
    
    func makeChatId(mode: Driver<Mode>) -> Driver<String> {
        mode
            .flatMapLatest { [weak self] mode -> Driver<String> in
                guard let self else { return .never() }
                
                func source() -> Single<String> {
                    switch mode {
                    case .newChat:
                        return self.chatManager
                            .createChat()
                            .map { chatId -> String in
                                guard let chatId else { throw ContentError(.notContent) }
                                return chatId
                            }
                    case .history(let chat):
                        return .just(chat.id)
                    }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else { return .empty() }
                    return tryAgain
                }
                
                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .asDriver(onErrorDriveWith: .never())
            }
    }
    
    func makeHistoryPage(mode: Driver<Mode>, didScrollToTop: Signal<Void>, chatId: Driver<String>) -> Driver<ChatMessagesPage> {
        chatId
            .withLatestFrom(mode) { ($0, $1) }
            .flatMapLatest { [weak self] args -> Driver<ChatMessagesPage> in
                let (chatId, mode) = args
                
                guard let self, mode.isHistory else { return .never() }
                
                var lastPage: ChatMessagesPage?
                
                func fetch(page: Int) -> Driver<ChatMessagesPage> {
                    chatManager
                        .messagesPage(chatId: chatId, page: page)
                        .compactMap { $0 }
                        .asDriver(onErrorDriveWith: .never())
                        .do(onNext: { page in
                            lastPage = page
                        })
                }
                
                let firstPage = fetch(page: 1)
                
                return firstPage
                    .flatMapLatest { firstPage -> Driver<ChatMessagesPage> in
                        didScrollToTop
                            .compactMap { lastPage }
                            .filter { (($0.page.current + 1) <= $0.page.total) && ($0.page.current != $0.page.total) }
                            .flatMapFirst { lastPage -> Driver<ChatMessagesPage> in
                                fetch(page: lastPage.page.current + 1)
                            }
                            .startWith(firstPage)
                    }
            }
    }
}

// MARK: Additional
private extension ChatViewModel.Mode {
    var isHistory: Bool {
        switch self {
        case .history:
            return true
        case .newChat:
            return false
        }
    }
}
