//
//  ScanImageResizeViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 31.10.2024.
//

import UIKit
import RxSwift
import RxCocoa
import Mantis

final class ScanImageResizeViewController: UIViewController {
    enum Result {
        case scanResult([Product])
        case retake
        case close
    }
    
    private lazy var mainView = ScanImageResizeView()
    
    private lazy var viewModel = ScanImageResizeViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private weak var cropVC: CropViewController?
    
    private lazy var didCroppedImageTrigger = PublishRelay<UIImage>()
    
    private lazy var closeButton = TapAreaButton()
    
    private let originalImage: UIImage
    private let complete: (Result) -> Void
    
    private init(image: UIImage, complete: @escaping (Result) -> Void) {
        self.originalImage = image
        self.complete = complete
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeCropView(image: originalImage)

        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: Binder(self) { base, void in
                base.cropVC?.didSelectReset()
            })
            .disposed(by: disposeBag)
        
        let output = viewModel.configure(input: ScanImageResizeViewModel.Input(
            didTapClose: closeButton.rx.tap.asSignal(),
            didAcceptPhoto: mainView.optionsView.didAcceptPhoto,
            didRetakePhoto: mainView.optionsView.didRetakePhoto,
            pushCroppedImage: didCroppedImageTrigger.asSignal()
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        addCloseButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyWhiteNavSettings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        applyDefaultNavSettings()
    }
}

// MARK: Public
extension ScanImageResizeViewController {
    static func make(image: UIImage, complete: @escaping (Result) -> Void) -> ScanImageResizeViewController {
        let vc = ScanImageResizeViewController(image: image, complete: complete)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: CropViewControllerDelegate
extension ScanImageResizeViewController: CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
        didCroppedImageTrigger.accept(cropped)
    }
    
    func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController, original: UIImage) {
        didCroppedImageTrigger.accept(original)
    }
    
    func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {}
}

// MARK: Private
private extension ScanImageResizeViewController {
    func makeCropView(image: UIImage) {
        var cropViewConfig = CropViewConfig()
        cropViewConfig.showAttachedRotationControlView = false
        
        var config = Config()
        config.showAttachedCropToolbar = false
        config.cropViewConfig = cropViewConfig
        
        let cropVC = Mantis.cropViewController(image: image, config: config)
        cropVC.delegate = self
        
        self.cropVC = cropVC
        
        addChild(cropVC)
        cropVC.view.translatesAutoresizingMaskIntoConstraints = false
        mainView.imageContainer.addSubview(cropVC.view)
        NSLayoutConstraint.activate([
            cropVC.view.leadingAnchor.constraint(equalTo: mainView.imageContainer.leadingAnchor),
            cropVC.view.trailingAnchor.constraint(equalTo: mainView.imageContainer.trailingAnchor),
            cropVC.view.topAnchor.constraint(equalTo: mainView.imageContainer.topAnchor),
            cropVC.view.bottomAnchor.constraint(equalTo: mainView.imageContainer.bottomAnchor)
        ])
        cropVC.didMove(toParent: self)
    }
    
    func route(_ route: ScanImageResizeViewModel.Route) {
        switch route {
        case .close:
            complete(.close)
        case .retake:
            complete(.retake)
        case .finish(let scanResult):
            complete(.scanResult(scanResult))
        }
    }
    
    func action(_ action: ScanImageResizeViewModel.Action) {
        switch action {
        case .crop:
            cropVC?.crop()
        case .changeOptionsState(let state):
            mainView.optionsView.setup(state: state)
        }
    }
    
    func addCloseButton() {
        closeButton.backgroundColor = UIColor.clear
        closeButton.setImage(UIImage(named: "Close.White"), for: .normal)
        
        let item = UIBarButtonItem(customView: closeButton)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 24.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 24.scale).isActive = true
        
        navigationItem.rightBarButtonItem = item
    }
    
    func applyWhiteNavSettings() {
        guard let nc = navigationController as? NavigationController else { return }
        
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Outfit.bold(size: 22.scale))
            .textAlignment(.center)
            .dictionary
        
        let settings = NavigationControllerSettings(
            backgroundImage: UIImage(),
            shadowImage: UIImage(),
            isTranslucent: true,
            tintColor: Appearance.mono100,
            titleTextAttrributes: attrs
        )
        nc.apply(settings: settings)
    }
    
    func applyDefaultNavSettings() {
        guard let nc = navigationController as? NavigationController else { return }
        
        let settings = NavigationControllerSettings.default()
        nc.apply(settings: settings)
    }
}
