//
//  ProductViewModel.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 03.04.2025.
//

import RxSwift
import RxCocoa

final class ProductViewModel {
    enum Route {
        case close
        case paygate
        case product(Product)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var activity = RxActivityIndicator()
    
    private let id: Driver<String>
    
    private lazy var productsManager = ProductsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(id: String) {
        self.id = BehaviorRelay(value: id).asDriver()
    }
}

// MARK: Public
extension ProductViewModel {
    struct Input {
        let didTapFavorite: Signal<Bool>
        let didTapClose: Signal<Void>
        let didSelectTab: Signal<ProductTabItemButton.Tab>
        let didSeletProduct: Signal<Product>
    }
    
    struct Output {
        let activity: Driver<Bool>
        let title: Driver<String>
        let image: Driver<URL>
        let favorite: Driver<Bool>
        let route: Driver<Route>
        let selectedTab: Driver<ProductTabItemButton.Tab>
        let elements: Driver<[ProductTableElement]>
    }
    
    func configure(input: Input) -> Output {
        let details = makeDetails(id: id)
        let selectedTab = makeSelectedTab(didSelectTab: input.didSelectTab)
        
        return Output(
            activity: activity.asDriver(),
            title: details.map { $0.title },
            image: details.map { $0.image },
            favorite: makeFavorite(
                details: details,
                didTapFavorite: input.didTapFavorite
            ),
            route: makeRoute(
                didTapClose: input.didTapClose,
                didTapFavorite: input.didTapFavorite
            ),
            selectedTab: selectedTab,
            elements: makeElements(
                details: details,
                selectedTab: selectedTab
            )
        )
    }
}

// MARK: Private
private extension ProductViewModel {
    func makeElements(
        details: Driver<ProductDetails>,
        selectedTab: Driver<ProductTabItemButton.Tab>
    ) -> Driver<[ProductTableElement]> {
        Driver
            .combineLatest(details, selectedTab)
            .map { details, selectedTab -> [ProductTableElement] in
                switch selectedTab {
                case .overview:
                    var result = [ProductTableElement]()
                    
                    let titleBrand = PTTitleBrandElement(
                        title: details.title,
                        brand: details.brand
                    )
                    result.append(.titleBrand(titleBrand))
                    
                    if let description = details.description {
                        result.append(.text(description))
                    }
                    
                    let stgp: [ExploreSTGPElement] = {
                        let skinTypes = details.tailoredForYou.skinTypes
                            .map { ExploreSTGPElement.skinType($0) }
                        let goals = details.tailoredForYou.goals
                            .map { ExploreSTGPElement.goal($0) }
                        let preferences = details.tailoredForYou.preferences
                            .map { ExploreSTGPElement.preference($0) }
                        
                        var result = skinTypes + goals + preferences
                        result.shuffle()
                        
                        return result
                    }()
                    result.append(.stgp(stgp))
                    
                    if let keyIngredients = details.keyIngredients {
                        let element = PTTitleValueElement(
                            title: "Product.KeyIngredients".localized,
                            value: keyIngredients.joined(separator: ", ")
                        )
                        
                        result.append(.titleValue(element))
                    }
                    
                    if let freeForm = details.freeForm {
                        let element = PTTitleValueElement(
                            title: "Product.FreeFrom".localized,
                            value: freeForm.joined(separator: ", ")
                        )
                        result.append(.titleValue(element))
                    }
                    
                    if let apply = details.apply {
                        let element = PTTitleValueElement(
                            title: "Product.Apply".localized,
                            value: apply
                        )
                        result.append(.titleValue(element))
                    }
                    
                    if !details.similar.isEmpty {
                        result.append(.similarProducts(details.similar))
                    }
                    
                    return result
                case .ingredients:
                    return [.text(details.ingredients.joined(separator: ", "))]
                }
            }
    }
    
    func makeDetails(id: Driver<String>) -> Driver<ProductDetails> {
        id
            .flatMapLatest { [weak self] id -> Driver<ProductDetails> in
                guard let self else { return .never() }
                
                func source() -> Single<ProductDetails> {
                    productsManager
                        .obtainDetails(productId: id)
                        .flatMap { details -> Single<ProductDetails> in
                            guard let details else {
                                throw ContentError(.notContent)
                            }
                            
                            return .just(details)
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    tryAgain?(error) ?? .empty()
                }
                
                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .trackActivity(activity)
                    .asDriver(onErrorDriveWith: .never())
            }
    }
    
    func makeFavorite(
        details: Driver<ProductDetails>,
        didTapFavorite: Signal<Bool>
    ) -> Driver<Bool> {
        let initial = details.map { $0.favorite }
        
        let action = didTapFavorite
            .asDriver(onErrorDriveWith: .never())
            .filter { _ in SessionManager().hasActiveSubscriptions() }
            .withLatestFrom(details) { ($0, $1.id) }
            .flatMapLatest { [weak self] saved, id -> Driver<Bool> in
                guard let self = self else { return .never() }
                
                func source() -> Single<Void> {
                    productsManager
                        .favorite(productId: id, action: saved ? .remove : .add)
                        .map { result -> Void in
                            guard result.success else {
                                throw ContentError(.notContent)
                            }
                            
                            return Void()
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    tryAgain?(error) ?? .empty()
                }
                
                return self.observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .asDriver(onErrorDriveWith: .never())
                    .map { !saved }
            }
        
        return Driver
            .merge(initial, action)
    }
    
    func makeRoute(
        didTapClose: Signal<Void>,
        didTapFavorite: Signal<Bool>,
        didSeletProduct: Signal<Product>
    ) -> Driver<Route> {
        let close = didTapClose
            .map { Route.close }
            .asDriver(onErrorDriveWith: .never())
        
        let paygate = didTapFavorite
            .compactMap { _ -> Route? in SessionManager().hasActiveSubscriptions() ? nil : .paygate }
            .asDriver(onErrorDriveWith: .never())
        
        let product = didSeletProduct
            .map { product -> Route in
                SessionManager().hasActiveSubscriptions() ? .product(product) : .paygate
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(close, paygate, product)
    }
    
    func makeSelectedTab(didSelectTab: Signal<ProductTabItemButton.Tab>) -> Driver<ProductTabItemButton.Tab> {
        didSelectTab
            .startWith(.overview)
            .asDriver(onErrorDriveWith: .never())
    }
}
