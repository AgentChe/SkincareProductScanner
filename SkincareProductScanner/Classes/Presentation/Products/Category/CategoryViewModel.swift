//
//  CategoryViewModel.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 26.03.2025.
//

import RxSwift
import RxCocoa

final class CategoryViewModel {
    enum Action {
        case openDetails(Product)
        case openPaygate
        case setup([Product])
        case append([Product])
    }
    
    private let category: Driver<ProductCategory>
    
    private lazy var firstPageActivity = RxActivityIndicator()
    private lazy var paginationActivity = RxActivityIndicator()
    
    private lazy var productsManager = ProductsManager()
    
    init(category: ProductCategory) {
        self.category = BehaviorRelay(value: category).asDriver()
    }
}

// MARK: Public
extension CategoryViewModel {
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
        let fetchProducts = makeProducts(
            didScrollToBottom: input.didScrollToBottom,
            category: category
        )
        
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
private extension CategoryViewModel {
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
    
    func makeProducts(
        didScrollToBottom: Signal<Void>,
        category: Driver<ProductCategory>
    ) -> Driver<FetchProductsResult> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int, category: ProductCategory) -> Driver<Page<[Product]>> {
            productsManager
                .search(presets: category.name, page: page)
                .trackActivity(page == 1 ? firstPageActivity : paginationActivity)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 }
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let firstPage = category.flatMapLatest { category -> Driver<Page<[Product]>> in
            fetch(page: 1, category: category)
        }
        let downloadedPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<[Product]>> in
                didScrollToBottom
                    .asDriver(onErrorDriveWith: .never())
                    .withLatestFrom(category)
                    .compactMap { category -> (ProductCategory, PageInfo)? in
                        guard let lastPageInfo else { return nil }
                        return (category, lastPageInfo)
                    }
                    .filter { category, pageInfo -> Bool in
                        let hasNext = ((pageInfo.current + 1) <= pageInfo.total)
                        let currentNotTotal = (pageInfo.current != pageInfo.total)
                        return hasNext && currentNotTotal
                    }
                    .flatMapFirst { category, lastPageInfo -> Driver<Page<[Product]>> in
                        fetch(page: lastPageInfo.current + 1, category: category)
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
