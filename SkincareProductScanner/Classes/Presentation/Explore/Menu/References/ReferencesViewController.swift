//
//  ReferencesViewController.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 14.03.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class ReferencesViewController: UIViewController {
    private lazy var mainView = ReferencesView()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Signal
            .merge(
                mainView.link1Button.didTap,
                mainView.link2Button.didTap
            )
            .emit(to: Binder(self) { base, url in
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension ReferencesViewController {
    static func make() -> ReferencesViewController {
        let vc = ReferencesViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "References.Title".localized
        return vc
    }
}
