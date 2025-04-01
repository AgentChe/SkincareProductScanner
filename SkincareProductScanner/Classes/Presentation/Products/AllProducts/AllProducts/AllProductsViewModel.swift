//
//  AllProductsViewModel.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 01.04.2025.
//

import RxSwift
import RxCocoa

final class AllProductsViewModel {
    enum Route {
        case filter(SelectedProductsFilters)
    }
    
    private lazy var productsManager = ProductsManager()
}

// MARK: Public
extension AllProductsViewModel {
    struct Input {
        let didTapFilter: Signal<Void>
        let didSelectFilters: Signal<SelectedProductsFilters>
    }
    
    struct Output {
        let route: Driver<Route>
        let filtersCount: Driver<Int>
    }
    
    func configure(input: Input) -> Output {
        let filters = makeFilters(didSelectFilters: input.didSelectFilters)
        
        return Output(
            route: makeRoute(
                didTapFilter: input.didTapFilter,
                filters: filters
            ),
            filtersCount: makeFiltersCount(filters: filters)
        )
    }
}

// MARK: Private
private extension AllProductsViewModel {
    func makeRoute(
        didTapFilter: Signal<Void>,
        filters: Driver<SelectedProductsFilters>
    ) -> Driver<Route> {
        let filter = didTapFilter
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(filters)
            .map { Route.filter($0) }
        
        return Driver
            .merge(filter)
    }
    
    func makeFilters(didSelectFilters: Signal<SelectedProductsFilters>) -> Driver<SelectedProductsFilters> {
        didSelectFilters
            .asDriver(onErrorDriveWith: .never())
            .startWith(SelectedProductsFilters(filters: []))
    }
    
    func makeFiltersCount(filters: Driver<SelectedProductsFilters>) -> Driver<Int> {
        filters
            .map { filters -> Int in
                filters.filters.reduce(0) { $0 + $1.itemsIds.count }
            }
    }
}
