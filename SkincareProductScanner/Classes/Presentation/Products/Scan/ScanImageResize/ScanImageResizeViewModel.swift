//
//  ScanImageResizeViewModel.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 31.10.2024.
//

import RxSwift
import RxCocoa

final class ScanImageResizeViewModel {
    enum Route {
        case close
        case retake
        case finish([Product])
    }
    
    enum Action {
        case crop
        case changeOptionsState(ScanImageResizeOptionsView.State)
    }
    
    private lazy var productsManager = ProductsManager()
}

// MARK: Public
extension ScanImageResizeViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didAcceptPhoto: Signal<Void>
        let didRetakePhoto: Signal<Void>
        let pushCroppedImage: Signal<UIImage>
    }
    
    struct Output {
        let route: Driver<Route>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        let scanResult = makeScanResult(pushCroppedImage: input.pushCroppedImage)
        let optionsState = makeOptionsState(
            pushCroppedImage: input.pushCroppedImage,
            scanResult: scanResult
        )
        
        return Output(
            route: makeRoute(
                didTapClose: input.didTapClose,
                didRetakePhoto: input.didRetakePhoto,
                scanResult: scanResult
            ),
            action: makeAction(
                didAcceptPhoto: input.didAcceptPhoto,
                optionsState: optionsState
            )
        )
    }
}

// MARK: Private
private extension ScanImageResizeViewModel {
    func makeRoute(
        didTapClose: Signal<Void>,
        didRetakePhoto: Signal<Void>,
        scanResult: Driver<ScanProductResult?>
    ) -> Driver<Route> {
        let close = didTapClose
            .map { Route.close }
            .asDriver(onErrorDriveWith: .never())
        
        let retake = didRetakePhoto
            .map { Route.retake }
            .asDriver(onErrorDriveWith: .never())
        
        let finish = scanResult
            .compactMap { result -> Route? in
                guard let result, let products = result.products else { return nil }
                return .finish(products)
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(close, retake, finish)
    }
    
    func makeAction(
        didAcceptPhoto: Signal<Void>,
        optionsState: Driver<ScanImageResizeOptionsView.State>
    ) -> Driver<Action> {
        let crop = didAcceptPhoto
            .map { Action.crop }
            .asDriver(onErrorDriveWith: .never())
        
        let changedOptionsState = optionsState
            .map { Action.changeOptionsState($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(crop, changedOptionsState)
    }
    
    func makeOptionsState(
        pushCroppedImage: Signal<UIImage>,
        scanResult: Driver<ScanProductResult?>
    ) -> Driver<ScanImageResizeOptionsView.State> {
        let preloader = pushCroppedImage
            .asDriver(onErrorDriveWith: .never())
            .map { _ in ScanImageResizeOptionsView.State.preloader }
        
        let incorrect = scanResult
            .compactMap { result -> ScanImageResizeOptionsView.State? in
                guard let result else { return .incorrect }
                
                return result.error != nil ? .incorrect : nil
            }
        
        return Driver
            .merge(preloader, incorrect)
            .startWith(.acceptPhoto)
    }
    
    func makeScanResult(pushCroppedImage: Signal<UIImage>) -> Driver<ScanProductResult?> {
        pushCroppedImage
            .flatMapLatest { [weak self] image -> Driver<ScanProductResult?> in
                guard let self else { return .never() }
                
                return productsManager
                    .scan(image: image)
                    .asDriver(onErrorJustReturn: nil)
            }
    }
}
