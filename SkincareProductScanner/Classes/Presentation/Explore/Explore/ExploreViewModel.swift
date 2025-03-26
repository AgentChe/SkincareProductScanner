//
//  ExploreViewModel.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 14.03.2025.
//

import RxSwift
import RxCocoa

final class ExploreViewModel {
    enum Route {
        case menu
        case recommendations
        case product(Product)
        case categories
        case category(ProductCategory)
        case bookmarks
        case allProducts
        case procedures
        case glossary
        case paygate
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var productsManager = ProductsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension ExploreViewModel {
    struct Input {
        let didTapMenu: Signal<Void>
        let didTapRecommendations: Signal<Void>
        let didSelectProduct: Signal<Product>
        let didTapCategories: Signal<Void>
        let didSelectCategory: Signal<ProductCategory>
        let didTapBookmarks: Signal<Void>
        let didTapAllProducts: Signal<Void>
        let didTapProcedures: Signal<Void>
        let didTapGlossary: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
        let elements: Driver<[ExploreTableElement]>
        let activity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let explore = makeExplore()
        
        return Output(
            route: makeRoute(
                didTapMenu: input.didTapMenu,
                didTapRecommendations: input.didTapRecommendations,
                didSelectProduct: input.didSelectProduct,
                didTapCategories: input.didTapCategories,
                didSelectCategory: input.didSelectCategory,
                didTapBookmarks: input.didTapBookmarks,
                didTapAllProducts: input.didTapAllProducts,
                didTapProcedures: input.didTapProcedures,
                didTapGlossary: input.didTapGlossary
            ),
            elements: makeElements(explore: explore),
            activity: activity.asDriver()
        )
    }
}

// MARK: Private
private extension ExploreViewModel {
    func makeRoute(
        didTapMenu: Signal<Void>,
        didTapRecommendations: Signal<Void>,
        didSelectProduct: Signal<Product>,
        didTapCategories: Signal<Void>,
        didSelectCategory: Signal<ProductCategory>,
        didTapBookmarks: Signal<Void>,
        didTapAllProducts: Signal<Void>,
        didTapProcedures: Signal<Void>,
        didTapGlossary: Signal<Void>
    ) -> Driver<Route> {
        let menu = didTapMenu
            .map { Route.menu }
            .asDriver(onErrorDriveWith: .never())
        
        let recommendations = didTapRecommendations
            .map { Route.recommendations }
            .asDriver(onErrorDriveWith: .never())
        
        let product = didSelectProduct
            .map { product -> Route in
                SessionManager().hasActiveSubscriptions() ? .product(product) : .paygate
            }
            .asDriver(onErrorDriveWith: .never())
        
        let categories = didTapCategories
            .map { Route.categories }
            .asDriver(onErrorDriveWith: .never())
        
        let category = didSelectCategory
            .map { Route.category($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let bookmarks = didTapBookmarks
            .map { Route.bookmarks }
            .asDriver(onErrorDriveWith: .never())
        
        let allProducts = didTapAllProducts
            .map { Route.allProducts }
            .asDriver(onErrorDriveWith: .never())
        
        let procedures = didTapProcedures
            .map { Route.procedures }
            .asDriver(onErrorDriveWith: .never())
        
        let glossary = didTapGlossary
            .map { Route.glossary }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(menu, recommendations, product, categories, category, bookmarks, allProducts, procedures, glossary)
    }
    
    func makeElements(explore: Driver<Explore>) -> Driver<[ExploreTableElement]> {
        explore
            .map { explore -> [ExploreTableElement] in
                let stgp: [ExploreSTGPElement] = {
                    let skinTypes = explore.recommendation.profile.skinTypes
                        .map { ExploreSTGPElement.skinType($0) }
                    let goals = explore.recommendation.profile.goals
                        .map { ExploreSTGPElement.goal($0) }
                    let preferences = explore.recommendation.profile.preferences
                        .map { ExploreSTGPElement.preference($0) }
                    
                    var result = skinTypes + goals + preferences
                    result.shuffle()
                    
                    return result
                }()
                
                return [
                    .recommendationsTitle,
                    .stgp(stgp),
                    .recommendationsProducts(explore.recommendation.products),
                    .bookmarks,
                    .categoriesTitle,
                    .categories(explore.productsCategories),
                    .catalogs
                ]
            }
    }
    
    func makeExplore() -> Driver<Explore> {
        func source() -> Single<Explore> {
            productsManager
                .obtainExplore()
                .flatMap { explore -> Single<Explore> in
                    guard let explore else {
                        throw ContentError(.notContent)
                    }
                    
                    return .just(explore)
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
