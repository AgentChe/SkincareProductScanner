//
//  ChangeProfileViewModel.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 14.03.2025.
//

import RxSwift
import RxCocoa

final class ChangeProfileViewModel {
    enum Route {
        case close
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension ChangeProfileViewModel {
    struct Input {
        let changedField: Signal<ChangeProfileFieldView.ChangedField>
    }
    
    struct Output {
        let activity: Driver<Bool>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            activity: activity.asDriver(),
            route: makeRoute(changedField: input.changedField)
        )
    }
}

// MARK: Private
private extension ChangeProfileViewModel {
    func makeRoute(changedField: Signal<ChangeProfileFieldView.ChangedField>) -> Driver<Route> {
        changedField
            .flatMapLatest { [weak self] field -> Driver<Route> in
                guard let self else { return .never() }
                
                func source() -> Single<Void> {
                    let result: Single<RequestResult> = {
                        switch field {
                        case .skinTypes(let ids):
                            return self.profileManager
                                .update(skinTypesIds: ids)
                        case .goals(let ids):
                            return self.profileManager
                                .update(goalsIds: ids)
                        case .preferences(let ids):
                            return self.profileManager
                                .update(preferencesIds: ids)
                        }
                    }()
                    
                    return result
                        .flatMap { result -> Single<Void> in
                            guard result.success else { return .error(ContentError(.notContent)) }
                            return .just(())
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    tryAgain?(error) ?? .empty()
                }
                
                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .trackActivity(activity)
                    .map { Route.close }
                    .asDriver(onErrorDriveWith: .never())
            }
    }
}
