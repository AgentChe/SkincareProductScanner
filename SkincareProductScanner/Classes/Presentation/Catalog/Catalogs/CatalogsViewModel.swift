//
//  CatalogsViewModel.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 17.03.2025.
//

import RxSwift
import RxCocoa

final class CatalogsViewModel {
    enum Route {
        case procedureDetails(Catalog)
        case glossaryDetails(Catalog)
        case paygate
        case disclaimer
        case references
    }
    
    private let item: Driver<CatalogsViewController.Item>
    
    private lazy var catalogManager = CatalogManager()
    
    init(item: CatalogsViewController.Item) {
        self.item = BehaviorRelay(value: item).asDriver()
    }
}

// MARK: Public
extension CatalogsViewModel {
    struct Input {
        let didSearch: Signal<String>
        let didSelect: Signal<CatalogsTableElement>
        let didTapDisclaimer: Signal<Void>
        let didTapReferences: Signal<Void>
    }
    
    struct Output {
        let elements: Driver<[CatalogsTableElement]>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        let activeSubscription = makeActiveSubscription()
        let catalogs = makeCatalogs(currentItem: item)
        let elements = makeElements(
            activeSubscription: activeSubscription,
            catalogs: catalogs
        )
        
        return Output(
            elements: makeFilteredElements(
                elements: elements,
                didSearch: input.didSearch
            ),
            route: makeRoute(
                didSelect: input.didSelect,
                currentItem: item,
                didTapDisclaimer: input.didTapDisclaimer,
                didTapReferences: input.didTapReferences
            )
        )
    }
}

// MARK: Private
private extension CatalogsViewModel {
    func makeFilteredElements(
        elements: Driver<[CatalogsTableElement]>,
        didSearch: Signal<String>
    ) -> Driver<[CatalogsTableElement]> {
        Driver
            .combineLatest(
                elements,
                didSearch.asDriver(onErrorDriveWith: .never())
            )
            .map { elements, search -> [CatalogsTableElement] in
                let cleaned = search.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if cleaned.isEmpty {
                    return elements
                }
                
                return elements.filter { element -> Bool in
                    element.catalog.name.contains(search)
                }
            }
    }
    
    func makeElements(
        activeSubscription: Driver<Bool>,
        catalogs: Driver<[Catalog]>
    ) -> Driver<[CatalogsTableElement]> {
        Driver
            .combineLatest(
                activeSubscription,
                catalogs
            )
            .map { activeSubscription, catalogs -> [CatalogsTableElement] in
                catalogs.enumerated().map { index, catalog -> CatalogsTableElement in
                    CatalogsTableElement(
                        catalog: catalog,
                        locked: (index >= 3) ? !activeSubscription : false
                    )
                }
            }
    }
    
    func makeCatalogs(currentItem: Driver<CatalogsViewController.Item>) -> Driver<[Catalog]> {
        currentItem
            .flatMapLatest { [weak self] item -> Driver<[Catalog]> in
                guard let self else { return .never() }
                
                switch item {
                case .glossary:
                    return catalogManager
                        .obtainGlossaries(forceUpdate: false)
                        .asDriver(onErrorJustReturn: [])
                case .procedure:
                    return catalogManager
                        .obtainProcedures(forceUpdate: false)
                        .asDriver(onErrorJustReturn: [])
                }
            }
    }
    
    func makeRoute(
        didSelect: Signal<CatalogsTableElement>,
        currentItem: Driver<CatalogsViewController.Item>,
        didTapDisclaimer: Signal<Void>,
        didTapReferences: Signal<Void>
    ) -> Driver<Route> {
        let detailsOrPaygate = didSelect
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(currentItem) { ($0, $1) }
            .map { element, currentItem -> Route in
                guard !element.locked else { return .paygate }
                
                switch currentItem {
                case .glossary:
                    return .glossaryDetails(element.catalog)
                case .procedure:
                    return .procedureDetails(element.catalog)
                }
            }
        
        let disclaimer = didTapDisclaimer
            .map { Route.disclaimer }
            .asDriver(onErrorDriveWith: .never())
        
        let references = didTapReferences
            .map { Route.references }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(detailsOrPaygate, disclaimer, references)
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .map { SessionManager().hasActiveSubscriptions() }
            .startWith(SessionManager().hasActiveSubscriptions())
            .asDriver(onErrorJustReturn: false)
    }
}
