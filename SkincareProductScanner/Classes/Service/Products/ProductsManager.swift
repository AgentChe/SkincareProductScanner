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
    ) -> Single<ProductsPage?>
    func favorites(page: Int) -> Single<ProductsPage?>
    func recommendations(page: Int) -> Single<ProductsPage?>
    func obtainDetails(productId: String) -> Single<ProductDetails?>
    func favorite(productId: String, action: ProductFavoriteRequest.Action) -> Single<RequestResult>
    func scan(image: UIImage) -> Single<ScanProductResult>
}

final class ProductsManager {
    private lazy var sessionManager = SessionManager()
    
    private lazy var restAPITransport = RestAPITransport()
}

// MARK: ProductsManagerProtocol
extension ProductsManager: ProductsManagerProtocol {
    // TODO
    func obtainExplore() -> Single<Explore?> {
//        let request = GetExploreRequest(
//            anonymousId: sessionManager.anonymousId,
//            internalId: sessionManager.internalId
//        )
//        
//        return restAPITransport
//            .callServerApi(requestBody: request)
//            .map { Explore(response: $0) }
        
        Single<Explore?>.create { single in
            let mock = Self.exploreMock()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                single(.success(mock))
            })
            
            return Disposables.create()
        }
    }
    
    func obtainFilters(forceUpdate: Bool) -> Single<ProductFilters?> {
        forceUpdate ? loadFilters() : cachedFilters()
    }
    
    func search(
        userInput: String? = nil,
        presets: String? = nil,
        filters: [String: [String]]? = nil,
        page: Int
    ) -> Single<ProductsPage?> {
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
            .map { ProductsPage(response: $0) }
    }
    
    func favorites(page: Int) -> Single<ProductsPage?> {
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
            .map { ProductsPage(response: $0) }
    }
    
    func recommendations(page: Int) -> Single<ProductsPage?> {
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
            .map { ProductsPage(response: $0) }
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
    
    func scan(image: UIImage) -> Single<ScanProductResult> {
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
    
    // TODO: remove
    static func exploreMock() -> Explore {
        let skinTypes: [SkinType] = {
            let strings = [
                "Normal",
                "City",
                "Dry",
                "Combination",
                "Sensitive"
            ]
            var skinTypes = strings.enumerated()
                .map { index, string in
                    SkinType(id: String(index), name: string)
                }
            skinTypes.shuffle()
            return Array(skinTypes.prefix(upTo: Int.random(in: 1...strings.count)))
        }()
        
        let goals: [Goal] = {
            let strings = [
                "Hydration",
                "Reduce acne",
                "Even skin tone",
                "Anti-aging",
                "Soothe sensitive skin",
                "Sun protection",
                "Deep cleansing"
            ]
            var goals = strings.enumerated()
                .map { index, string in
                    Goal(id: String(index), name: string)
                }
            goals.shuffle()
            return Array(goals.prefix(upTo: Int.random(in: 1...strings.count)))
        }()
        
        let preferences: [Preference] = {
            let strings = [
                "Vegan",
                "Cruelty Free",
                "EU-Allergen Free",
                "Reef Safe",
                "Malassezia Safe",
                "Alcohol Free",
                "Silicone Free",
                "Fragrance Free",
                "Sulfate Free",
                "Paraben Free",
                "Oil Free",
                "Non-Comedogenic",
                "Fatty Alcohol Free"
            ]
            var preferences = strings.enumerated()
                .map { index, string in
                    Preference(id: String(index), name: string)
                }
            preferences.shuffle()
            return Array(preferences.prefix(upTo: Int.random(in: 1...strings.count)))
        }()
        
        let profile = ExploreRecommendationProfile(
            skinTypes: skinTypes,
            goals: goals,
            preferences: preferences
        )
        
        let recommendation = ExploreRecommendation(
            profile: profile,
            products: Self.productsMock()
        )
        
        return Explore(
            recommendation: recommendation,
            productsCategories: Self.productsCategoriesMock()
        )
    }
    
    // TODO: remove
    static func productsCategoriesMock() -> [ProductCategory] {
        [
            ProductCategory(
                id: "1",
                name: "Holy grails",
                image: URL(string: "https://i.postimg.cc/BZTd1q2t/temp-Image1-Nxtc8.avif")!,
                description: "CeraVe, The Ordinary, Avene"
            ),
            
            ProductCategory(
                id: "2",
                name: "Trending",
                image: URL(string: "https://i.postimg.cc/XXD231mB/temp-Imageeit-WFI.avif")!,
                description: "Dior, The Ordinary, Avene"
            ),
            
            ProductCategory(
                id: "3",
                name: "Hydrating",
                image: URL(string: "https://i.postimg.cc/cvfTRxHf/temp-Imagekw5stn.avif")!,
                description: "CeraVe, The Ordinaly, Avene"
            ),
            
            ProductCategory(
                id: "4",
                name: "Oil-control",
                image: URL(string: "https://i.postimg.cc/HVc6L41Z/temp-Imagela-IEUO.avif")!,
                description: "Dior, The Ordinary, Avene"
            ),
            
            ProductCategory(
                id: "5",
                name: "Soothing",
                image: URL(string: "https://i.postimg.cc/LncNgYHH/temp-Image-Shkztm.avif")!,
                description: "Dior, The Ordinary, Avene"
            )
        ]
    }
    
    // TODO: remove
    static func productsMock(count: Int = 10) -> [Product] {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        
        var products = [Product]()
        
        if count <= 0 {
            return []
        }
        
        for i in 0...(count - 1) {
            let nameCount = Int.random(in: 5...15)
            let brandCount = Int.random(in: 3...25)
            
            let product = Product(
                id: String(i),
                title: String((0..<nameCount).map{ _ in letters.randomElement()! }),
                image: URL(string: "https://i.postimg.cc/htfyMgQL/temp-Imagewsizoa.avif")!,
                brand: String((0..<brandCount).map{ _ in letters.randomElement()! })
            )
            
            products.append(product)
        }
        
        return products
    }
}
