//
//  DisclaimerViewController.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 14.03.2025.
//

import UIKit

final class DisclaimerViewController: UIViewController {
    private lazy var mainView = DisclaimerView()
    
    override func loadView() {
        view = mainView
    }
}

// MARK: Public
extension DisclaimerViewController {
    static func make() -> DisclaimerViewController {
        let vc = DisclaimerViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "Disclaimer.Title".localized
        return vc
    }
}
