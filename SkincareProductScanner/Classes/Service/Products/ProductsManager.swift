//
//  ProductsManager.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 22.03.2025.
//

import RxSwift

protocol ProductsManagerProtocol {
    func obtainExplore() -> Single<Explore?>
    func obtainFilters(forceUpdate: Bool) -> Single<ProductFilters?>
    func search(
        userInput: String?,
        presets: String?,
        filters: [String: [String]]?,
        page: Int
    ) -> Single<Page<[Product]>?>
    func favorites(page: Int) -> Single<Page<[Product]>?>
    func recommendations(page: Int) -> Single<Page<[Product]>?>
    func obtainDetails(productId: String) -> Single<ProductDetails?>
    func favorite(productId: String, action: ProductFavoriteRequest.Action) -> Single<RequestResult>
    func scan(image: UIImage) -> Single<ScanProductResult?>
}

final class ProductsManager {
    private lazy var sessionManager = SessionManager()
    
    private lazy var restAPITransport = RestAPITransport()
}

// MARK: ProductsManagerProtocol
extension ProductsManager: ProductsManagerProtocol {
    func obtainExplore() -> Single<Explore?> {
        let request = GetExploreRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { Explore(response: $0) }
    }
    
    func obtainFilters(forceUpdate: Bool) -> Single<ProductFilters?> {
        forceUpdate ? loadFilters() : cachedFilters()
    }
    
    func search(
        userInput: String? = nil,
        presets: String? = nil,
        filters: [String: [String]]? = nil,
        page: Int
    ) -> Single<Page<[Product]>?> {
        let request = GetProductsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            search: userInput,
            presets: presets,
            filters: filters,
            page: page
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { Product.map(response: $0) }
    }
    
    func favorites(page: Int) -> Single<Page<[Product]>?> {
        let request = GetProductsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            search: nil,
            presets: "favorite",
            filters: nil,
            page: page
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { Product.map(response: $0) }
    }
    
    func recommendations(page: Int) -> Single<Page<[Product]>?> {
        let request = GetProductsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            search: nil,
            presets: "recommendation",
            filters: nil,
            page: page
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { Product.map(response: $0) }
    }
    
    func obtainDetails(productId: String) -> Single<ProductDetails?> {
        let request = GetProductDetailsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: productId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { ProductDetails(response: $0) }
    }
    
    func favorite(productId: String, action: ProductFavoriteRequest.Action) -> Single<RequestResult> {
        let request = ProductFavoriteRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: productId,
            action: action
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { requestResult in
                guard requestResult.success else { return }
                
                switch action {
                case .add:
                    ProductsMediator.shared.addProductToFavorite(id: productId)
                case .remove:
                    ProductsMediator.shared.removeProductFromFavorite(id: productId)
                }
            })
    }
    
    func scan(image: UIImage) -> Single<ScanProductResult?> {
        let request = ScanRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            image: image
        )
        
        return restAPITransport
            .callServerApi(formDataBody: request)
            .map { ScanProductResult(response: $0) }
    }
}

// MARK: Private
private extension ProductsManager {
    enum Constants {
        static let filtersKey = "pm_filters_key"
    }
    
    func loadFilters() -> Single<ProductFilters?> {
        let request = GetProductsFiltersRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { ProductFilters(response: $0) }
            .do(onSuccess: { filters in
                guard let filters, let data = try? JSONEncoder().encode(filters) else { return }
                
                UserDefaults.standard.set(data, forKey: Constants.filtersKey)
            })
    }
    
    func cachedFilters() -> Single<ProductFilters?> {
        Single<ProductFilters?>.create { single in
            let filters: ProductFilters? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.filtersKey) else { return nil }
                return try? JSONDecoder().decode(ProductFilters.self, from: data)
            }()
            
            single(.success(filters))
            
            return Disposables.create()
        }
    }
}
