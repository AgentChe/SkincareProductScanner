//
//  MenuViewModel.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 14.03.2025.
//

import RxSwift
import RxCocoa

final class MenuViewModel {
    enum Route {
        case skinType
        case goals
        case preferenes
        case references
        case disclaimer
        case open(URL)
    }
}

// MARK: Public
extension MenuViewModel {
    struct Input {
        let didTapDisclaimer: Signal<Void>
        let didTapReferences: Signal<Void>
        let didSelectElement: Signal<MenuTableElement>
    }
    
    struct Output {
        let route: Driver<Route>
        let elements: Driver<[MenuTableElement]>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(
                didTapDisclaimer: input.didTapDisclaimer,
                didTapReferences: input.didTapReferences,
                didSelectElement: input.didSelectElement
            ),
            elements: makeElements()
        )
    }
}

// MARK: Private
private extension MenuViewModel {
    func makeRoute(
        didTapDisclaimer: Signal<Void>,
        didTapReferences: Signal<Void>,
        didSelectElement: Signal<MenuTableElement>
    ) -> Driver<Route> {
        let disclaimer = didTapDisclaimer
            .map { Route.disclaimer }
            .asDriver(onErrorDriveWith: .never())
        
        let references = didTapReferences
            .map { Route.references }
            .asDriver(onErrorDriveWith: .never())
        
        let routeAtSelectElement = didSelectElement
            .map { element -> Route in
                switch element.route {
                case .profileEntity(let route):
                    switch route {
                    case .skinType:
                        return .skinType
                    case .goals:
                        return .goals
                    case .preferences:
                        return .preferenes
                    }
                case .info(let route):
                    switch route {
                    case .disclaimer:
                        return .disclaimer
                    case .references:
                        return .references
                    }
                case .url(let route):
                    switch route {
                    case .termsOfUse:
                        return .open(GlobalDefinitions.termsOfServiceUrl)
                    case .privacyPolicy:
                        return .open(GlobalDefinitions.privacyPolicyUrl)
                    case .support:
                        return .open(GlobalDefinitions.contactUsUrl)
                    }
                }
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(disclaimer, references, routeAtSelectElement)
    }
    
    func makeElements() -> Driver<[MenuTableElement]> {
        .deferred {
            .just([
                MenuTableElement(route: .profileEntity(.skinType)),
                MenuTableElement(route: .profileEntity(.goals)),
                MenuTableElement(route: .profileEntity(.preferences)),
                MenuTableElement(route: .info(.references)),
                MenuTableElement(route: .info(.disclaimer)),
                MenuTableElement(route: .url(.termsOfUse)),
                MenuTableElement(route: .url(.privacyPolicy)),
                MenuTableElement(route: .url(.support), separatorHidden: true)
            ])
        }
    }
}
