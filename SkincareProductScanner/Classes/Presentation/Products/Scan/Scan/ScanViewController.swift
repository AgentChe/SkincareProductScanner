//
//  ScanViewController.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 12.09.2024.
//

import UIKit
import RxSwift
import PhotosUI
import AVFoundation

final class ScanViewController: UIViewController {
    private lazy var mainView = ScanView()
    
    private lazy var viewModel = ScanViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private let didClose: (() -> Void)?
    private let didResult: ((UIImage) -> Void)?
    
    private lazy var closeButton = TapAreaButton()
    
    private lazy var cameraService: CameraService = {
        let cameraService = CameraService()
        cameraService.delegate = self
        return cameraService
    }()
    
    private init(didClose: (() -> Void)?, didResult: ((UIImage) -> Void)?) {
        self.didClose = didClose
        self.didResult = didResult
        
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
        
        let output = viewModel.configure(input: ScanViewModel.Input(
            didTapDismiss: closeButton.rx.tap.asSignal(),
            didTapSelectImageFromLibrary: mainView.wallpapersButton.rx.tap.asSignal(),
            didTapTakePhoto: mainView.takeButton.rx.tap.asSignal(),
            didTapAllowAccess: mainView.permissionProblemView.allowAccessButton.rx.tap.asSignal(),
            didTapFlash: mainView.flashButton.rx.tap.asSignal()
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
        
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .bind(to: Binder(self) { base, _ in
                base.setupCameraLayer()
            })
            .disposed(by: disposeBag)
        
        addCloseButton()
    }
}

// MARK: Public
extension ScanViewController {
    static func make(didClose: (() -> Void)? = nil, didResult: ((UIImage) -> Void)? = nil) -> ScanViewController {
        let vc = ScanViewController(didClose: didClose, didResult: didResult)
        vc.modalPresentationStyle = .fullScreen
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: PHPickerViewControllerDelegate
extension ScanViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results
            .map (\.itemProvider)
            .filter { $0.canLoadObject(ofClass: UIImage.self) }
            .first
        guard let itemProvider else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { image, error in
            if let image = image as? UIImage {
                DispatchQueue.main.async { [weak self] in
                    self?.complete(image: image)
                }
            }
        }
    }
}

// MARK: CameraServiceDelegate
extension ScanViewController: CameraServiceDelegate {
    func setPhoto(image: UIImage) {
        complete(image: image)
    }
}

// MARK: Private
private extension ScanViewController {
    func route(_ route: ScanViewModel.Route) {
        switch route {
        case .dismiss:
            didClose?()
        case .selectImageFromLibrary:
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            configuration.selectionLimit = 1
            configuration.preferredAssetRepresentationMode = .automatic
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            
            present(picker, animated: true)
        case .requestPermissionInSettings:
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            
            UIApplication.shared.open(url)
        }
    }
    
    func action(_ action: ScanViewModel.Action) {
        switch action {
        case .takePhoto:
            let photoSettings = AVCapturePhotoSettings()
            photoSettings.isHighResolutionPhotoEnabled = true
            photoSettings.flashMode = .off
            cameraService.photoOutput.capturePhoto(with: photoSettings, delegate: cameraService)
        case .toggleFlashMode:
            cameraService.toggleFlash()
        }
    }
    
    func complete(image: UIImage?) {
        guard let image else { return }
        
        didResult?(image)
    }
    
    func setupCameraLayer() {
        func ui(authorized: Bool) {
            mainView.permissionProblemView.isHidden = authorized
            mainView.takeButton.isHidden = !authorized
            
            if authorized {
                let previewLayer = AVCaptureVideoPreviewLayer(session: cameraService.captureSession) as AVCaptureVideoPreviewLayer
                previewLayer.frame = mainView.bounds
                previewLayer.videoGravity = .resizeAspectFill
                mainView.layer.insertSublayer(previewLayer, at: 0)
            }
        }
        
        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthStatus {
        case .authorized:
            ui(authorized: true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                ui(authorized: authorized)
            }
        default:
            ui(authorized: false)
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
}
