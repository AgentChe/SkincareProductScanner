//
//  ChatsViewModel.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

import RxSwift
import RxCocoa

final class ChatsViewModel {
    enum Route {
        case requestConfirmDelete(Chat)
        case chat(Chat)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var firstPageActivity = RxActivityIndicator()
    private lazy var paginationActivity = RxActivityIndicator()
    
    private lazy var chatManager = ChatManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension ChatsViewModel {
    struct Input {
        let didWantDelete: Signal<Chat>
        let didConfirmDelete: Signal<Chat>
        let selectChat: Signal<Chat>
        let didScrollToBottom: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
        let sections: Driver<[ChatsTableSection]>
        let firstPageActivity: Driver<Bool>
        let paginationActivity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let chatDeleted = makeDeleteChat(didConfirmDelete: input.didConfirmDelete)
        let fetchPageChats = makePageChats(didScrollToBottom: input.didScrollToBottom)
        let allChats = makeAllChats(
            fetchPageChats: fetchPageChats,
            deletedChat: chatDeleted
        )
        
        return Output(
            route: makeRoute(
                didWantDelete: input.didWantDelete,
                selectChat: input.selectChat
            ),
            sections: makeSections(chats: allChats),
            firstPageActivity: firstPageActivity.asDriver(),
            paginationActivity: paginationActivity.asDriver()
        )
    }
}

// MARK: Private
private extension ChatsViewModel {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "en_GB")
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    func makeRoute(
        didWantDelete: Signal<Chat>,
        selectChat: Signal<Chat>
    ) -> Driver<Route> {
        let requestConfirmDelete = didWantDelete
            .map { Route.requestConfirmDelete($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let chat = selectChat
            .map { Route.chat($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(requestConfirmDelete, chat)
    }
    
    func makeSections(chats: Driver<[Chat]>) -> Driver<[ChatsTableSection]> {
        chats
            .map { chats -> [ChatsTableSection] in
                let calendar = Calendar.current
                
                let grouped = Dictionary(grouping: chats) { chat -> Date in
                    let components = calendar.dateComponents([.year, .month, .day], from: chat.created)
                    return calendar.date(from: components) ?? calendar.startOfDay(for: Date())
                }
                
                return grouped
                    .sorted(by: { $0.key > $1.key })
                    .map { date, chats -> ChatsTableSection in
                        ChatsTableSection(
                            title: Self.dateFormatter.string(from: date),
                            chats: chats
                        )
                    }
            }
    }
    
    func makeAllChats(
        fetchPageChats: Driver<Page<[Chat]>>,
        deletedChat: Signal<String>
    ) -> Driver<[Chat]> {
        enum Action {
            case fetch(Page<[Chat]>)
            case deleted(String)
        }
        
        let action = Driver
            .merge(
                fetchPageChats.map { Action.fetch($0) },
                deletedChat.map { Action.deleted($0) }.asDriver(onErrorDriveWith: .never())
            )
        
        return action
            .scan([]) { allChats, action -> [Chat] in
                switch action {
                case .fetch(let page):
                    return page.info.current == 1 ? page.elements : (allChats + page.elements)
                case .deleted(let id):
                    var result = allChats
                    result.removeAll(where: { $0.id == id })
                    return result
                }
            }
    }
    
    func makePageChats(didScrollToBottom: Signal<Void>) -> Driver<Page<[Chat]>> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int) -> Driver<Page<[Chat]>> {
            chatManager
                .chats(page: page)
                .trackActivity(page == 1 ? firstPageActivity : paginationActivity)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 }
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let firstPage = fetch(page: 1)
        let downloadedPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<[Chat]>> in
                didScrollToBottom
                    .asDriver(onErrorDriveWith: .never())
                    .compactMap { lastPageInfo }
                    .filter { lastPageInfo -> Bool in
                        let nextPage = lastPageInfo.current + 1
                        let nextPageNotTotal = nextPage <= lastPageInfo.total
                        let currentNotTotal = lastPageInfo.current != lastPageInfo.total
                        return nextPageNotTotal && currentNotTotal
                    }
                    .flatMapFirst { lastPageInfo -> Driver<Page<[Chat]>> in
                        fetch(page: lastPageInfo.current + 1)
                    }
                    .startWith(firstPage)
            }
        return downloadedPage
    }
    
    func makeDeleteChat(didConfirmDelete: Signal<Chat>) -> Signal<String> {
        didConfirmDelete
            .flatMapLatest { [weak self] chat -> Signal<String> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<String> {
                    self.chatManager
                        .deleteChat(id: chat.id)
                        .map { chat.id }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .asSignal(onErrorSignalWith: .never())
            }
    }
}
