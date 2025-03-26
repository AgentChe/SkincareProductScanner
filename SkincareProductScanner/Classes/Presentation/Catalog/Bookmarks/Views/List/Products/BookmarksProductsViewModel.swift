//
//  BookmarksProductsViewModel.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 25.03.2025.
//

import RxSwift
import RxCocoa

final class BookmarksProductsViewModel {
    enum Action {
        case openDetails(Product)
        case openPaygate
        case setup([Product])
        case append([Product])
        case remove(String)
    }
    
    private lazy var firstPageActivity = RxActivityIndicator()
    private lazy var paginationActivity = RxActivityIndicator()
    
    private lazy var productsManager = ProductsManager()
}

// MARK: Public
extension BookmarksProductsViewModel {
    struct Input {
        let didSelect: Signal<Product>
        let didScrollToBottom: Signal<Void>
    }
    
    struct Output {
        let action: Driver<Action>
        let firstPageActivity: Driver<Bool>
        let paginationActivity: Driver<Bool>
        let isEmpty: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let removedProduct = makeRemovedProduct()
        let fetchProducts = makeProducts(didScrollToBottom: input.didScrollToBottom)
        
        return Output(
            action: makeAction(
                didSelect: input.didSelect,
                fetchProducts: fetchProducts,
                removedProduct: removedProduct
            ),
            firstPageActivity: firstPageActivity.asDriver(),
            paginationActivity: paginationActivity.asDriver(),
            isEmpty: makeIsEmpty(
                fetchResult: fetchProducts,
                removedProduct: removedProduct
            )
        )
    }
}

// MARK: Private
private extension BookmarksProductsViewModel {
    struct FetchProductsResult {
        let products: [Product]
        let isFirstPage: Bool
    }
    
    func makeIsEmpty(
        fetchResult: Driver<FetchProductsResult>,
        removedProduct: Driver<String>
    ) -> Driver<Bool> {
        enum Action {
            case fetchResult(FetchProductsResult)
            case removed(String)
        }
        
        let action = Driver
            .merge(
                fetchResult.map { Action.fetchResult($0) },
                removedProduct.map { Action.removed($0) }
            )
        
        let allProducts = action
            .scan([]) { allProducts, action -> [Product] in
                switch action {
                case .fetchResult(let fetchResult):
                    return fetchResult.isFirstPage ? fetchResult.products : (allProducts + fetchResult.products)
                case .removed(let id):
                    var result = allProducts
                    result.removeAll(where: { $0.id == id })
                    return result
                }
            }
        
        return allProducts
            .map { $0.isEmpty }
            .startWith(true)
    }
    
    func makeAction(
        didSelect: Signal<Product>,
        fetchProducts: Driver<FetchProductsResult>,
        removedProduct: Driver<String>
    ) -> Driver<Action> {
        let selectRoute = didSelect
            .map {
                SessionManager().hasActiveSubscriptions() ? Action.openDetails($0) : Action.openPaygate
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
        
        let remove = removedProduct
            .map { Action.remove($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(selectRoute, elements, remove)
    }
    
    func makeProducts(didScrollToBottom: Signal<Void>) -> Driver<FetchProductsResult> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int) -> Driver<Page<[Product]>> {
            productsManager
                .favorites(page: page)
                .trackActivity(page == 1 ? firstPageActivity : paginationActivity)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 }
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let triggerFirstLoad = ProductsMediator.shared
            .didAddProductToFavorite
            .map { _ in Void() }
            .startWith(())
        
        let firstPage = triggerFirstLoad.flatMapLatest {
            fetch(page: 1)
        }
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
    
    func makeRemovedProduct() -> Driver<String> {
        ProductsMediator.shared
            .didRemoveProductFromFavorite
            .asDriver(onErrorDriveWith: .never())
    }
}
