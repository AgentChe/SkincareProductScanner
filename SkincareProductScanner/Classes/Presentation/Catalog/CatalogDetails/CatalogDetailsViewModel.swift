//
//  CatalogDetailsViewModel.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 23.10.2024.
//

import RxSwift
import RxCocoa

final class CatalogDetailsViewModel {
    enum Route {
        case paygate
        case disclaimer
        case references
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var activity = RxActivityIndicator()
    
    private let item: Driver<CatalogDetailsViewController.Item>
    private let catalog: Driver<Catalog>
    
    private lazy var needPaygateTrigger = PublishRelay<Void>()
    
    private lazy var catalogManager = CatalogManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(item: CatalogDetailsViewController.Item, catalog: Catalog) {
        self.item = BehaviorRelay(value: item).asDriver()
        self.catalog = BehaviorRelay(value: catalog).asDriver()
    }
}

// MARK: Public
extension CatalogDetailsViewModel {
    struct Input {
        let didTapMark: Signal<Bool>
        let didTapDisclaimer: Signal<Void>
        let didTapReferences: Signal<Void>
    }
    
    struct Output {
        let marked: Driver<Bool>
        let sections: Driver<[CDTableSection]>
        let activity: Driver<Bool>
        let route: Driver<Route>
        let disposable: Disposable
    }
    
    func configure(input: Input) -> Output {
        let canSave = makeCanSave(
            bookmarksCatalogs: makeBookmarkCatalogs(),
            activeSubscription: makeActiveSubscription()
        )
        let catalogDetails = makeCatalogDetails(
            catalog: catalog,
            item: item
        )
        
        return Output(
            marked: makeBookmark(
                item: item,
                catalogDetails: catalogDetails,
                didTapMark: input.didTapMark,
                canSave: canSave
            ),
            sections: makeSections(catalogDetails: catalogDetails),
            activity: activity.asDriver(),
            route: makeRoute(
                didTapDisclaimer: input.didTapDisclaimer,
                didTapReferences: input.didTapReferences
            ),
            disposable: canSave.drive()
        )
    }
}

// MARK: Private
private extension CatalogDetailsViewModel {
    func makeSections(catalogDetails: Driver<CatalogDetails>) -> Driver<[CDTableSection]> {
        catalogDetails
            .map { catalogDetails -> [CDTableSection] in
                var result = [CDTableSection]()
                
                let nameSection = CDTableSection(
                    opened: false,
                    openedElements: [],
                    closedElements: [.name(catalogDetails.name)]
                )
                result.append(nameSection)
                
                catalogDetails.sections.enumerated().forEach { index, catalogDetailsSection in
                    let isLast = (catalogDetails.sections.count - 1) == index
                    
                    let sectionElement = CDSectionElement(
                        name: catalogDetailsSection.name,
                        opened: index == 1
                    )
                    
                    var openedElements: [CDTableElement] = [.section(sectionElement)]
                    catalogDetailsSection.blocks.forEach { block in
                        switch block.value {
                        case .text(let text):
                            if let title = block.title {
                                openedElements.append(.title(title))
                            }
                            openedElements.append(.text(text))
                        case .image(let url):
                            openedElements.append(.image(url))
                        }
                    }
                    if !isLast {
                        openedElements.append(.separator)
                    }
                    
                    let section = CDTableSection(
                        opened: index == 0,
                        openedElements: openedElements,
                        closedElements: [.section(sectionElement), isLast ? nil : .separator].compactMap { $0 }
                    )
                    result.append(section)
                }
                
                return result
            }
    }
    
    func makeBookmark(
        item: Driver<CatalogDetailsViewController.Item>,
        catalogDetails: Driver<CatalogDetails>,
        didTapMark: Signal<Bool>,
        canSave: Driver<Bool>
    ) -> Driver<Bool> {
        let initial = catalogDetails.map { $0.saved }
        
        let action = didTapMark
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(item) { ($0, $1) }
            .withLatestFrom(catalogDetails) {  ($0.0, $0.1, $1) }
            .withLatestFrom(canSave) { ($0.0, $0.1, $0.2, $1) }
            .flatMapLatest { [weak self] saved, item, catalogDetails, canSave -> Driver<Bool> in
                guard let self = self else { return .never() }
                
                if !saved && !canSave {
                    self.needPaygateTrigger.accept(Void())
                    return .just(saved)
                }
                
                func source() -> Single<Void> {
                    let result: Single<RequestResult> = {
                        switch item {
                        case .glossary:
                            return saved ? self.catalogManager.unsaveGlossary(id: catalogDetails.id) : self.catalogManager.saveGlossary(id: catalogDetails.id)
                        case .procedure:
                            return saved ? self.catalogManager.unsaveProcedure(id: catalogDetails.id) : self.catalogManager.saveProcedure(id: catalogDetails.id)
                        }
                    }()
                    
                    return result
                        .map { result -> Void in
                            guard result.success else {
                                throw ContentError(.notContent)
                            }
                            
                            return Void()
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .asDriver(onErrorDriveWith: .never())
                    .map { !saved }
            }
        
        return Driver
            .merge(initial, action)
    }
    
    func makeCatalogDetails(catalog: Driver<Catalog>, item: Driver<CatalogDetailsViewController.Item>) -> Driver<CatalogDetails> {
        catalog
            .withLatestFrom(item) { ($0, $1) }
            .flatMapLatest { [weak self] args -> Driver<CatalogDetails> in
                guard let self = self else { return .never() }
                
                let (catalog, item) = args
                
                func source() -> Single<CatalogDetails> {
                    let details: Single<CatalogDetails?> = {
                        switch item {
                        case .glossary:
                            return self.catalogManager
                                .obtainGlossaryDetails(id: catalog.id)
                                .catch { error in .just(nil) }
                        case .procedure:
                            return self.catalogManager
                                .obtainProcedureDetails(id: catalog.id)
                                .catch { error in .just(nil) }
                        }
                    }()
                    
                    return details
                        .flatMap { details -> Single<CatalogDetails> in
                            guard let details = details else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(details)
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .trackActivity(self.activity)
                    .asDriver(onErrorDriveWith: .never())
            }
    }
    
    func makeRoute(
        didTapDisclaimer: Signal<Void>,
        didTapReferences: Signal<Void>
    ) -> Driver<Route> {
        let paygate = needPaygateTrigger
            .map { Route.paygate }
            .asDriver(onErrorDriveWith: .never())
        
        let disclaimer = didTapDisclaimer
            .map { Route.disclaimer }
            .asDriver(onErrorDriveWith: .never())
        
        let references = didTapReferences
            .map { Route.references }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(paygate, disclaimer, references)
    }
    
    func makeCanSave(
        bookmarksCatalogs: Driver<[Catalog]>,
        activeSubscription: Driver<Bool>
    ) -> Driver<Bool> {
        activeSubscription
            .flatMapLatest { activeSubscription -> Driver<Bool> in
                guard !activeSubscription else { return .just(true) }
                
                return bookmarksCatalogs
                    .map { $0.count < 1 }
            }
    }
    
    func makeBookmarkCatalogs() -> Driver<[Catalog]> {
        Signal
            .merge(
                CatalogMediator.shared.didSaveProcedureId.map { id in Void() },
                CatalogMediator.shared.didSaveGlossaryId.map { id in Void() },
                CatalogMediator.shared.didUnsaveProcedureId.map { id in Void() },
                CatalogMediator.shared.didUnsaveGlossaryId.map { id in Void() }
            )
            .startWith(Void())
            .withLatestFrom(item)
            .flatMapLatest { [weak self] item -> Signal<[Catalog]> in
                guard let self = self else { return .never() }
                
                switch item {
                case .procedure:
                    return catalogManager
                        .obtainBookmarksProcedures()
                        .asSignal(onErrorJustReturn: [])
                case .glossary:
                    return catalogManager
                        .obtainBookmarksGlossaries()
                        .asSignal(onErrorJustReturn: [])
                }
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .map { SessionManager().hasActiveSubscriptions() }
            .startWith(SessionManager().hasActiveSubscriptions())
            .asDriver(onErrorJustReturn: false)
    }
}
