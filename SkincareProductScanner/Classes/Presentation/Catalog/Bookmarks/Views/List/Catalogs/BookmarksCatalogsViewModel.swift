//
//  BookmarksCatalogsViewModel.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 19.03.2025.
//

import RxSwift
import RxCocoa

final class BookmarksCatalogsViewModel {
    enum Route {
        case disclaimer
        case references
        case paygate
        case procedure(Catalog)
        case glossary(Catalog)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var activity = RxActivityIndicator()
    
    private let entity: Driver<BookmarksCatalogsViewController.Entity>
    
    private lazy var catalogManager = CatalogManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(entity: BookmarksCatalogsViewController.Entity) {
        self.entity = BehaviorRelay(value: entity).asDriver()
    }
}

// MARK: Public
extension BookmarksCatalogsViewModel {
    struct Input {
        let didTapDisclaimer: Signal<Void>
        let didTapReferences: Signal<Void>
        let didSelect: Signal<BookmarksCatalogsTableElement>
    }
    
    struct Output {
        let route: Driver<Route>
        let elements: Driver<[BookmarksCatalogsTableElement]>
        let isEmpty: Driver<Bool>
        let isLoading: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let elements = makeElements(
            activeSubscription: makeActiveSubscription(),
            catalogs: makeCatalogs(entity: entity)
        )
        
        return Output(
            route: makeRoute(
                didTapDisclaimer: input.didTapDisclaimer,
                didTapReferences: input.didTapReferences,
                didSelect: input.didSelect,
                entity: entity
            ),
            elements: elements,
            isEmpty: makeIsEmpty(elements: elements),
            isLoading: activity.asDriver()
        )
    }
}

// MARK: Private
private extension BookmarksCatalogsViewModel {
    func makeRoute(
        didTapDisclaimer: Signal<Void>,
        didTapReferences: Signal<Void>,
        didSelect: Signal<BookmarksCatalogsTableElement>,
        entity: Driver<BookmarksCatalogsViewController.Entity>
    ) -> Driver<Route> {
        let disclaimer = didTapDisclaimer
            .map { Route.disclaimer }
            .asDriver(onErrorDriveWith: .never())
        
        let references = didTapReferences
            .map { Route.references }
            .asDriver(onErrorDriveWith: .never())
        
        let selectRoute = didSelect
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(entity) { ($0, $1) }
            .map { element, entity -> Route in
                guard !element.locked else {
                    return Route.paygate
                }
                
                switch entity {
                case .procedures:
                    return Route.procedure(element.catalog)
                case .glossary:
                    return Route.glossary(element.catalog)
                }
            }
        
        return Driver
            .merge(disclaimer, references, selectRoute)
    }
    
    func makeIsEmpty(elements: Driver<[BookmarksCatalogsTableElement]>) -> Driver<Bool> {
        elements
            .map { $0.isEmpty }
            .startWith(true)
    }
    
    func makeElements(
        activeSubscription: Driver<Bool>,
        catalogs: Driver<[Catalog]>
    ) -> Driver<[BookmarksCatalogsTableElement]> {
        Driver
            .combineLatest(activeSubscription, catalogs) { activeSubscription, catalogs -> [BookmarksCatalogsTableElement] in
                catalogs.map { catalog -> BookmarksCatalogsTableElement in
                    BookmarksCatalogsTableElement(catalog: catalog, locked: !activeSubscription)
                }
            }
    }
    
    func makeCatalogs(entity: Driver<BookmarksCatalogsViewController.Entity>) -> Driver<[Catalog]> {
        entity.flatMapLatest { entity -> Driver<[Catalog]> in
            let downloadTrigger: Signal<Void> = {
                switch entity {
                case .procedures:
                    return CatalogMediator.shared
                        .didSaveProcedureId
                        .map { id in Void() }
                case .glossary:
                    return CatalogMediator.shared
                        .didSaveGlossaryId
                        .map { id in Void() }
                }
            }()
            
            let downloaded = downloadTrigger
                .startWith(())
                .flatMapLatest { [weak self] void -> Driver<[Catalog]> in
                    guard let self = self else {
                        return .never()
                    }
                    
                    func source() -> Single<[Catalog]> {
                        switch entity {
                        case .procedures:
                            return self.catalogManager
                                .obtainBookmarksProcedures()
                        case .glossary:
                            return self.catalogManager
                                .obtainBookmarksGlossaries()
                        }
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
                        .trackActivity(activity)
                        .asDriver(onErrorDriveWith: .never())
                }
            
            return downloaded
                .flatMapLatest { catalogs -> Driver<[Catalog]> in
                    let removeTrigger: Signal<String> = {
                        switch entity {
                        case .procedures:
                            return CatalogMediator.shared
                                .didUnsaveProcedureId
                        case .glossary:
                            return CatalogMediator.shared
                                .didUnsaveGlossaryId
                        }
                    }()
                    
                    return removeTrigger
                        .scan(catalogs) { catalogs, id -> [Catalog] in
                            var result = catalogs
                            result.removeAll(where: { $0.id == id })
                            return result
                        }
                        .startWith(catalogs)
                        .asDriver(onErrorJustReturn: [])
                }
        }
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .map { SessionManager().hasActiveSubscriptions() }
            .startWith(SessionManager().hasActiveSubscriptions())
            .asDriver(onErrorJustReturn: false)
    }
}
