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
    }
}

// MARK: Public
extension ExploreViewModel {
    struct Input {
        let didTapMenu: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(
                didTapMenu: input.didTapMenu
            )
        )
    }
}

// MARK: Private
private extension ExploreViewModel {
    func makeRoute(
        didTapMenu: Signal<Void>
    ) -> Driver<Route> {
        let menu = didTapMenu
            .map { Route.menu }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(menu)
    }
}
