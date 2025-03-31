//
//  ScanAssembly.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 31.10.2024.
//

import UIKit
import AVFoundation

final class ScanAssembly {
    func scan(from: UIViewController) {
        if !SessionManager().hasActiveSubscriptions() {
            let vc = PaygateViewController.make()
            from.present(vc, animated: true)
            
            return
        }
        
        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthStatus {
        case .authorized:
            startScanFlow(from: from)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                DispatchQueue.main.async { [weak self] in
                    authorized ? self?.startScanFlow(from: from) : self?.notPermission(from: from)
                }
            }
        default:
            notPermission(from: from)
        }
    }
}

// MARK: Private
private extension ScanAssembly {
    func startScanFlow(from: UIViewController) {
        let nc = NavigationController()
        nc.modalPresentationStyle = .fullScreen
        
        let cameraVC = Self.makeCameraVC(nc: nc)
        
        nc.setViewControllers([cameraVC], animated: false)
        
        from.present(nc, animated: true)
    }
    
    func notPermission(from: UIViewController) {
        let alert = UIAlertController(
            title: "Scan.NotPermissions.Title".localized,
            message: "Scan.NotPermissions.Text".localized,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK".localized, style: .cancel)
        alert.addAction(okAction)
        
        from.present(alert, animated: true)
    }
    
    static func makeCameraVC(nc: NavigationController) -> UIViewController {
        ScanViewController.make(didClose: { [weak nc] in
            nc?.dismiss(animated: true)
        }, didResult: { [weak nc] image in
            let resizeVC = ScanImageResizeViewController.make(image: image) { [weak nc] result in
                switch result {
                case .scanResult(let products):
                    let vc = ScanProductsViewController.make(products: products) { [weak nc] in
                        guard let nc else { return }
                        
                        let cameraVC = makeCameraVC(nc: nc)
                        nc.setViewControllers([cameraVC], animated: true)
                    } didClose: { [weak nc] in
                        nc?.dismiss(animated: true)
                    }
                    
                    nc?.setViewControllers([vc], animated: true)
                case .retake:
                    nc?.popViewController(animated: true)
                case .close:
                    nc?.dismiss(animated: true)
                }
            }
            
            nc?.pushViewController(resizeVC, animated: true)
        })
    }
}
