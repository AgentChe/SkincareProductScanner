//
//  MenuViewController.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 14.03.2025.
//

import UIKit
import RxSwift

final class MenuViewController: UIViewController {
    private lazy var mainView = MenuView()
    
    private lazy var viewModel = MenuViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: MenuViewModel.Input(
            didTapDisclaimer: mainView.bottomInfoView.didTapDisclaimer,
            didTapReferences: mainView.bottomInfoView.didTapReferences,
            didSelectElement: mainView.tableView.didSelect
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route: route)
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension MenuViewController {
    static func make() -> MenuViewController {
        let vc = MenuViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "Menu.Title".localized
        return vc
    }
}

// MARK: Private
private extension MenuViewController {
    func route(route: MenuViewModel.Route) {
        switch route {
        case .skinType:
            let vc = ChangeProfileViewController.make(field: .skinTypes)
            navigationController?.pushViewController(vc, animated: true)
        case .goals:
            let vc = ChangeProfileViewController.make(field: .goals)
            navigationController?.pushViewController(vc, animated: true)
        case .preferenes:
            let vc = ChangeProfileViewController.make(field: .preferences)
            navigationController?.pushViewController(vc, animated: true)
        case .references:
            let vc = ReferencesViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .disclaimer:
            let vc = DisclaimerViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .open(let url):
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
