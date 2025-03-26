//
//  CategoriesViewModel.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 26.03.2025.
//

import RxSwift
import RxCocoa

final class CategoriesViewModel {
    enum Route {
        case category(ProductCategory)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var productsManager = ProductsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension CategoriesViewModel {
    struct Input {
        let didSelectCategory: Signal<ProductCategory>
    }
    
    struct Output {
        let route: Driver<Route>
        let elements: Driver<[ProductCategory]>
        let activity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(didSelectCategory: input.didSelectCategory),
            elements: makeCategories(),
            activity: activity.asDriver()
        )
    }
}

// MARK: Private
private extension CategoriesViewModel {
    func makeRoute(didSelectCategory: Signal<ProductCategory>) -> Driver<Route> {
        didSelectCategory
            .asDriver(onErrorDriveWith: .never())
            .map { Route.category($0) }
    }
    
    func makeCategories() -> Driver<[ProductCategory]> {
        func source() -> Single<[ProductCategory]> {
            productsManager
                .obtainExplore()
                .flatMap { explore -> Single<[ProductCategory]> in
                    guard let explore else {
                        throw ContentError(.notContent)
                    }
                    
                    return .just(explore.productsCategories)
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
