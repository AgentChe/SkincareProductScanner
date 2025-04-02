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
        case preset(String)
        case product(Product)
    }
    
    private lazy var firstPageProductsActivity = RxActivityIndicator()
    private lazy var paginationProductActivity = RxActivityIndicator()
    
    private lazy var productsManager = ProductsManager()
}

// MARK: Public
extension AllProductsViewModel {
    struct Input {
        let didTapFilter: Signal<Void>
        let didSelectFilters: Signal<SelectedProductsFilters>
        let didChangedInputText: Signal<String>
        let didTapSearch: Signal<String>
        let didSelectPreset: Signal<String>
        let didSelectProduct: Signal<Product>
        let didScrollToBottom: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
        let filtersCount: Driver<Int>
        let sections: Driver<[APTableSection]>
        let firstPageActivity: Driver<Bool>
        let paginationActivity: Driver<Bool>
        let emptyViewHidden: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let inputText = input.didChangedInputText
            .startWith("")
            .asDriver(onErrorDriveWith: .never())
        let filters = makeFilters(didSelectFilters: input.didSelectFilters)
        let startSearchProductsParams = makeStartSearchProductsParams(
            didTapSearch: input.didTapSearch,
            didSelectFilters: input.didSelectFilters,
            didInput: inputText,
            filters: filters
        )
        let fetchPageProducts = makePageProducts(
            startSearchProductsParams: startSearchProductsParams,
            didScrollToBottom: input.didScrollToBottom
        )
        let allProducts = makeAllProducts(
            startSearchProductsParams: startSearchProductsParams,
            fetchPageProducts: fetchPageProducts
        )
        let firstPageActivity = firstPageProductsActivity.asDriver()
        
        return Output(
            route: makeRoute(
                didTapFilter: input.didTapFilter,
                filters: filters,
                didSelectPreset: input.didSelectPreset,
                didSelectProduct: input.didSelectProduct
            ),
            filtersCount: makeFiltersCount(filters: filters),
            sections: makeSections(
                startSearchProductsParams: startSearchProductsParams,
                presetsSections: makePresetsSections(),
                productsSections: makeProductsSections(allProducts: allProducts)
            ),
            firstPageActivity: firstPageActivity,
            paginationActivity: paginationProductActivity.asDriver(),
            emptyViewHidden: makeEmptyViewHidden(
                startSearchProductsParams: startSearchProductsParams,
                allProducts: allProducts,
                firstPageActivity: firstPageActivity
            )
        )
    }
}

// MARK: Private
private extension AllProductsViewModel {
    struct SearchParams {
        let inputText: String
        let filters: SelectedProductsFilters
    }
    
    func makeEmptyViewHidden(
        startSearchProductsParams: Driver<SearchParams>,
        allProducts: Driver<[Product]>,
        firstPageActivity: Driver<Bool>
    ) -> Driver<Bool> {
        Driver
            .combineLatest(
                startSearchProductsParams,
                allProducts,
                firstPageActivity
            )
            .map { params, allProducts, activity -> Bool in
                if activity || params.isEmpty { return true }
                
                return !allProducts.isEmpty
            }
            .startWith(true)
    }
    
    func makeRoute(
        didTapFilter: Signal<Void>,
        filters: Driver<SelectedProductsFilters>,
        didSelectPreset: Signal<String>,
        didSelectProduct: Signal<Product>
    ) -> Driver<Route> {
        let filter = didTapFilter
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(filters)
            .map { Route.filter($0) }
        
        let preset = didSelectPreset
            .map { Route.preset($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let product = didSelectProduct
            .map { Route.product($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(filter, preset, product)
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
    
    func makeSections(
        startSearchProductsParams: Driver<SearchParams>,
        presetsSections: Driver<[APTableSection]>,
        productsSections: Driver<[APTableSection]>
    ) -> Driver<[APTableSection]> {
        Driver
            .combineLatest(startSearchProductsParams, presetsSections, productsSections)
            .map { startSearchProductsParams, presetsSections, productsSections -> [APTableSection] in
                startSearchProductsParams.isEmpty ? presetsSections : productsSections
            }
    }
    
    func makePresetsSections() -> Driver<[APTableSection]> {
        productsManager
            .obtainFilters(forceUpdate: false)
            .asDriver(onErrorJustReturn: nil)
            .map { filters -> [APTableSection] in
                let presets = filters?.presets ?? []
                
                return presets.enumerated().map { index, presetFilter -> APTableSection in
                    let sectionName = APPresetSectionElement(
                        image: presetFilter.image,
                        name: presetFilter.name,
                        opened: index == 0
                    )
                    let section = APTableElement.presetSection(sectionName)
                    
                    let items = presetFilter.items.map { APTableElement.presetItem($0) }
                    
                    return APTableSection(
                        openedElements: [section] + items,
                        closedElements: [section],
                        opened: index == 0
                    )
                }
            }
    }
    
    func makeProductsSections(allProducts: Driver<[Product]>) -> Driver<[APTableSection]> {
        allProducts
            .map { products -> [APTableSection] in
                let elements = products.map { APTableElement.product($0) }
                let section = APTableSection(
                    openedElements: elements,
                    closedElements: elements,
                    opened: true
                )
                return [section]
            }
    }
    
    func makeAllProducts(
        startSearchProductsParams: Driver<SearchParams>,
        fetchPageProducts: Driver<Page<[Product]>>
    ) -> Driver<[Product]> {
        enum Action {
            case startSearch(SearchParams)
            case fetch(Page<[Product]>)
        }
        
        let action = Driver
            .merge(
                startSearchProductsParams.map { Action.startSearch($0) },
                fetchPageProducts.map { Action.fetch($0) }
            )
        
        return action
            .scan([]) { allProducts, action -> [Product] in
                switch action {
                case .startSearch:
                    return []
                case .fetch(let page):
                    return page.info.current == 1 ? page.elements : (allProducts + page.elements)
                }
            }
            .startWith([])
    }
    
    func makePageProducts(
        startSearchProductsParams: Driver<SearchParams>,
        didScrollToBottom: Signal<Void>
    ) -> Driver<Page<[Product]>> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int, params: SearchParams) -> Driver<Page<[Product]>> {
            let filters = params.filters.filters.reduce([String: [String]]()) { dict, filter -> [String: [String]] in
                var result = dict
                result[filter.parentFilterId] = filter.itemsIds
                return result
            }
            
            return productsManager
                .search(
                    userInput: params.inputText,
                    filters: filters,
                    page: page
                )
                .trackActivity(page == 1 ? firstPageProductsActivity : paginationProductActivity)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 }
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let firstPage = startSearchProductsParams
            .filter { !$0.isEmpty }
            .flatMapLatest { params -> Driver<Page<[Product]>> in
                fetch(page: 1, params: params)
            }
        let downloadedPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<[Product]>> in
                didScrollToBottom
                    .asDriver(onErrorDriveWith: .never())
                    .withLatestFrom(startSearchProductsParams)
                    .filter { !$0.isEmpty }
                    .compactMap { params -> (AllProductsViewModel.SearchParams, PageInfo)? in
                        guard let lastPageInfo else { return nil }
                        return (params, lastPageInfo)
                    }
                    .filter { _, lastPageInfo -> Bool in
                        let nextPage = lastPageInfo.current + 1
                        let nextPageNotTotal = nextPage <= lastPageInfo.total
                        let currentNotTotal = lastPageInfo.current != lastPageInfo.total
                        return nextPageNotTotal && currentNotTotal
                    }
                    .flatMapFirst { params, lastPageInfo -> Driver<Page<[Product]>> in
                        fetch(page: lastPageInfo.current + 1, params: params)
                    }
                    .startWith(firstPage)
            }
        return downloadedPage
    }
    
    func makeStartSearchProductsParams(
        didTapSearch: Signal<String>,
        didSelectFilters: Signal<SelectedProductsFilters>,
        didInput: Driver<String>,
        filters: Driver<SelectedProductsFilters>
    ) -> Driver<SearchParams> {
        let params = Driver
            .combineLatest(didInput, filters)
            .map { inputText, filters -> SearchParams in
                SearchParams(
                    inputText: inputText,
                    filters: filters
                )
            }
        
        let trigger = Driver
            .merge(
                didTapSearch
                    .asDriver(onErrorDriveWith: .never())
                    .map { _ in Void() },
                didSelectFilters
                    .asDriver(onErrorDriveWith: .never())
                    .map { _ in Void() }
            )
        
        return Driver
            .merge(
                params
                    .asObservable()
                    .take(1)
                    .asDriver(onErrorDriveWith: .never()),
                trigger
                    .withLatestFrom(params)
            )
    }
}

// MARK: Additional
private extension AllProductsViewModel.SearchParams {
    var isEmpty: Bool {
        let emptyInputText = inputText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
        let emptyFilters = filters.filters.isEmpty
        return emptyInputText && emptyFilters
    }
}
