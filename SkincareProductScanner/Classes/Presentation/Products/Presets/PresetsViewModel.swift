//
//  PresetsViewModel.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 26.03.2025.
//

import RxSwift
import RxCocoa

final class PresetsViewModel {
    enum Action {
        case openDetails(Product)
        case openPaygate
        case setup([Product])
        case append([Product])
    }
    
    private let preset: Driver<String>
    
    private lazy var firstPageActivity = RxActivityIndicator()
    private lazy var paginationActivity = RxActivityIndicator()
    
    private lazy var productsManager = ProductsManager()
    
    init(preset: String) {
        self.preset = BehaviorRelay(value: preset).asDriver()
    }
}

// MARK: Public
extension PresetsViewModel {
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
            preset: preset
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
private extension PresetsViewModel {
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
        preset: Driver<String>
    ) -> Driver<FetchProductsResult> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int, preset: String) -> Driver<Page<[Product]>> {
            productsManager
                .search(presets: preset, page: page)
                .trackActivity(page == 1 ? firstPageActivity : paginationActivity)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 }
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let firstPage = preset.flatMapLatest { preset -> Driver<Page<[Product]>> in
            fetch(page: 1, preset: preset)
        }
        let downloadedPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<[Product]>> in
                didScrollToBottom
                    .asDriver(onErrorDriveWith: .never())
                    .withLatestFrom(preset)
                    .compactMap { preset -> (String, PageInfo)? in
                        guard let lastPageInfo else { return nil }
                        return (preset, lastPageInfo)
                    }
                    .filter { preset, pageInfo -> Bool in
                        let hasNext = ((pageInfo.current + 1) <= pageInfo.total)
                        let currentNotTotal = (pageInfo.current != pageInfo.total)
                        return hasNext && currentNotTotal
                    }
                    .flatMapFirst { preset, lastPageInfo -> Driver<Page<[Product]>> in
                        fetch(page: lastPageInfo.current + 1, preset: preset)
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
