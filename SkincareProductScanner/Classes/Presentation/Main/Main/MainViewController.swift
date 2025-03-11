//
//  MainViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 28.01.2025.
//

import UIKit
import RxSwift

final class MainViewController: UIViewController {
    lazy var mainView = MainView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var coordinator = MainCoordinator(parentVC: self)
    
    private let requestReview: Bool
    
    private init(requestReview: Bool) {
        self.requestReview = requestReview

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
        
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .bind(to: Binder(self) { base, _ in
                base.coordinator.change(tab: .explore)
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge([
                mainView.tabView.exploreButton
                    .rx.tap.map { TabView.Tab.explore },
                mainView.tabView.chatButton
                    .rx.tap.map { TabView.Tab.chat }
            ])
            .bind(to: Binder(self) { base, tab in
                base.coordinator.change(tab: tab)
            })
            .disposed(by: disposeBag)
        
        mainView.tabView.scanButton
            .rx.tap.bind(to: (Binder(self) { base, void in
                // TODO
            }))
            .disposed(by: disposeBag)
        
        if requestReview {
            RequestReview.request()
        }
    }
}

// MARK: Public
extension MainViewController {
    static func make(requestReview: Bool) -> MainViewController {
        let vc = MainViewController(requestReview: requestReview)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}
