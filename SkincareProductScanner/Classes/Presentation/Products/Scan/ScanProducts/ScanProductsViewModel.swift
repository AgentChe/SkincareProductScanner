//
//  ScanProductsViewModel.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 31.03.2025.
//

import RxSwift
import RxCocoa

final class ScanProductsViewModel {
    enum Route {
        case close
        case newSearch
        case product(Product)
    }
    
    private let products: Driver<[Product]>
    
    init(products: [Product]) {
        self.products = BehaviorRelay(value: products).asDriver()
    }
}

// MARK: Public
extension ScanProductsViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didTapNewSearch: Signal<Void>
        let didSelect: Signal<Product>
    }
    
    struct Output {
        let route: Driver<Route>
        let isEmpty: Driver<Bool>
        let elements: Driver<[Product]>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(
                didTapClose: input.didTapClose,
                didTapNewSearch: input.didTapNewSearch,
                didSelect: input.didSelect
            ),
            isEmpty: products.map { $0.isEmpty },
            elements: products
        )
    }
}

// MARK: Private
private extension ScanProductsViewModel {
    func makeRoute(
        didTapClose: Signal<Void>,
        didTapNewSearch: Signal<Void>,
        didSelect: Signal<Product>
    ) -> Driver<Route> {
        let close = didTapClose
            .map { Route.close }
            .asDriver(onErrorDriveWith: .never())
        
        let newSearch = didTapNewSearch
            .map { Route.newSearch }
            .asDriver(onErrorDriveWith: .never())
        
        let product = didSelect
            .map { Route.product($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(close, newSearch, product)
    }
}
