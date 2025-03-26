//
//  RecommendationsViewModel.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 25.03.2025.
//

import RxSwift
import RxCocoa

final class RecommendationsViewModel {
    enum Action {
        case openDetails(Product)
        case openPaygate
        case setup([Product])
        case append([Product])
    }
    
    private lazy var firstPageActivity = RxActivityIndicator()
    private lazy var paginationActivity = RxActivityIndicator()
    
    private lazy var productsManager = ProductsManager()
}

// MARK: Public
extension RecommendationsViewModel {
    struct Input {
        let didSelect: Signal<Product>
        let didScrollToBottom: Signal<Void>
    }
    
    struct Output {
        let action: Driver<Action>
        let firstPageActivity: Driver<Bool>
        let paginationActivity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let fetchProducts = makeProducts(didScrollToBottom: input.didScrollToBottom)
        
        return Output(
            action: makeAction(
                didSelect: input.didSelect,
                fetchProducts: fetchProducts
            ),
            firstPageActivity: firstPageActivity.asDriver(),
            paginationActivity: paginationActivity.asDriver()
        )
    }
}

// MARK: Private
private extension RecommendationsViewModel {
    struct FetchProductsResult {
        let products: [Product]
        let isFirstPage: Bool
    }
    
    func makeAction(
        didSelect: Signal<Product>,
        fetchProducts: Driver<FetchProductsResult>
    ) -> Driver<Action> {
        let openDetails = didSelect
            .map { product -> Action in
                SessionManager().hasActiveSubscriptions() ? .openDetails(product) : .openPaygate
            }
            .asDriver(onErrorDriveWith: .never())
        
        let elements = fetchProducts
            .map { fetchProducts -> Action in
                if fetchProducts.isFirstPage {
                    return .setup(fetchProducts.products)
                } else {
                    return .append(fetchProducts.products)
                }
            }
        
        return Driver
            .merge(openDetails, elements)
    }
    
    func makeProducts(didScrollToBottom: Signal<Void>) -> Driver<FetchProductsResult> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int) -> Driver<Page<[Product]>> {
            productsManager
                .recommendations(page: page)
                .trackActivity(page == 1 ? firstPageActivity : paginationActivity)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 }
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let firstPage = fetch(page: 1)
        let downloadedPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<[Product]>> in
                didScrollToBottom
                    .asDriver(onErrorDriveWith: .never())
                    .compactMap { lastPageInfo }
                    .filter { pageInfo -> Bool in
                        let hasNext = ((pageInfo.current + 1) <= pageInfo.total)
                        let currentNotTotal = (pageInfo.current != pageInfo.total)
                        return hasNext && currentNotTotal
                    }
                    .flatMapFirst { lastPageInfo -> Driver<Page<[Product]>> in
                        fetch(page: lastPageInfo.current + 1)
                    }
                    .startWith(firstPage)
            }
        
        return downloadedPage
            .map { page -> FetchProductsResult in
                FetchProductsResult(
                    products: page.elements,
                    isFirstPage: page.info.current == 1
                )
            }
    }
}
