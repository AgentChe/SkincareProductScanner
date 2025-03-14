//
//  ExploreViewController.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 14.03.2025.
//

import UIKit
import RxSwift

final class ExploreViewController: UIViewController {
    private lazy var mainView = ExploreView()
    
    private lazy var viewModel = ExploreViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: ExploreViewModel.Input(
            didTapMenu: mainView.headerView.menuButton.rx.tap.asSignal()
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: Public
extension ExploreViewController {
    static func make() -> ExploreViewController {
        let vc = ExploreViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Public
private extension ExploreViewController {
    func route(_ route: ExploreViewModel.Route) {
        switch route {
        case .menu:
            let vc = MenuViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
