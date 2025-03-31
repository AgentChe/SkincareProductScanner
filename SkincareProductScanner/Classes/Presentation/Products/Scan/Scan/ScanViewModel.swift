//
//  ScanViewModel.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 12.09.2024.
//

import RxSwift
import RxCocoa

final class ScanViewModel {
    enum Route {
        case dismiss, selectImageFromLibrary, requestPermissionInSettings
    }
    
    enum Action {
        case takePhoto
        case toggleFlashMode
    }
}

// MARK: Public
extension ScanViewModel {
    struct Input {
        let didTapDismiss: Signal<Void>
        let didTapSelectImageFromLibrary: Signal<Void>
        let didTapTakePhoto: Signal<Void>
        let didTapAllowAccess: Signal<Void>
        let didTapFlash: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(
                didTapDismiss: input.didTapDismiss,
                didTapSelectImageFromLibrary: input.didTapSelectImageFromLibrary,
                didTapAllowAccess: input.didTapAllowAccess
            ),
            action: makeAction(
                didTapTakePhoto: input.didTapTakePhoto,
                didTapFlash: input.didTapFlash
            )
        )
    }
}

// MARK: Private
private extension ScanViewModel {
    func makeRoute(
        didTapDismiss: Signal<Void>,
        didTapSelectImageFromLibrary: Signal<Void>,
        didTapAllowAccess: Signal<Void>
    ) -> Driver<Route> {
        let dismiss = didTapDismiss
            .map { Route.dismiss }
            .asDriver(onErrorDriveWith: .never())
        
        let selectImageFromLibrary = didTapSelectImageFromLibrary
            .map { Route.selectImageFromLibrary }
            .asDriver(onErrorDriveWith: .never())
        
        let requestPermissionInSettings = didTapAllowAccess
            .map { Route.requestPermissionInSettings }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(dismiss, selectImageFromLibrary, requestPermissionInSettings)
    }
    
    func makeAction(
        didTapTakePhoto: Signal<Void>,
        didTapFlash: Signal<Void>
    ) -> Driver<Action> {
        let takePhoto = didTapTakePhoto
            .map { Action.takePhoto }
            .asDriver(onErrorDriveWith: .never())
        
        let toggleFlash = didTapFlash
            .map { Action.toggleFlashMode }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(takePhoto, toggleFlash)
    }
}
