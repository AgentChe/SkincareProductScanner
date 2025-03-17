//
//  ExploreViewModel.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 14.03.2025.
//

import RxSwift
import RxCocoa

final class ExploreViewModel {
    enum Route {
        case menu
        case bookmarks
        case allProducts
        case procedures
        case glossary
    }
}

// MARK: Public
extension ExploreViewModel {
    struct Input {
        let didTapMenu: Signal<Void>
        let didTapBookmarks: Signal<Void>
        let didTapAllProducts: Signal<Void>
        let didTapProcedures: Signal<Void>
        let didTapGlossary: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
        let elements: Driver<[ExploreTableElement]>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(
                didTapMenu: input.didTapMenu,
                didTapBookmarks: input.didTapBookmarks,
                didTapAllProducts: input.didTapAllProducts,
                didTapProcedures: input.didTapProcedures,
                didTapGlossary: input.didTapGlossary
            ),
            elements: makeElements()
        )
    }
}

// MARK: Private
private extension ExploreViewModel {
    func makeRoute(
        didTapMenu: Signal<Void>,
        didTapBookmarks: Signal<Void>,
        didTapAllProducts: Signal<Void>,
        didTapProcedures: Signal<Void>,
        didTapGlossary: Signal<Void>
    ) -> Driver<Route> {
        let menu = didTapMenu
            .map { Route.menu }
            .asDriver(onErrorDriveWith: .never())
        
        let bookmarks = didTapBookmarks
            .map { Route.bookmarks }
            .asDriver(onErrorDriveWith: .never())
        
        let allProducts = didTapAllProducts
            .map { Route.allProducts }
            .asDriver(onErrorDriveWith: .never())
        
        let procedures = didTapProcedures
            .map { Route.procedures }
            .asDriver(onErrorDriveWith: .never())
        
        let glossary = didTapGlossary
            .map { Route.glossary }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(menu, bookmarks, allProducts, procedures, glossary)
    }
    
    func makeElements() -> Driver<[ExploreTableElement]> {
        .deferred {
            .just([
                .bookmarks,
                .catalogs
            ])
        }
    }
}
