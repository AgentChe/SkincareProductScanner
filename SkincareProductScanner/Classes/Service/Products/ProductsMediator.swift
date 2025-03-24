//
//  ProductsMediator.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 22.03.2025.
//

import RxSwift
import RxCocoa

final class ProductsMediator {
    static let shared = ProductsMediator()
    
    private lazy var didAddProductToFavoriteTrigger = PublishRelay<String>()
    private lazy var didRemoveProductFromFavoriteTrigger = PublishRelay<String>()
    
    private init() {}
}

// MARK: Public
extension ProductsMediator {
    func addProductToFavorite(id: String) {
        didAddProductToFavoriteTrigger.accept(id)
    }
    
    func removeProductFromFavorite(id: String) {
        didRemoveProductFromFavoriteTrigger.accept(id)
    }
    
    var didAddProductToFavorite: Signal<String> {
        didAddProductToFavoriteTrigger.asSignal()
    }
    
    var didRemoveProductFromFavorite: Signal<String> {
        didRemoveProductFromFavoriteTrigger.asSignal()
    }
}
