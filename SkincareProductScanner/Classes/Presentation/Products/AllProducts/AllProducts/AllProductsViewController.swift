//
//  AllProductsViewController.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 01.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class AllProductsViewController: UIViewController {
    private lazy var mainView = AllProductsView()
    
    private lazy var viewModel = AllProductsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didSelectFiltersTrigger = PublishRelay<SelectedProductsFilters>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: AllProductsViewModel.Input(
            didTapFilter: mainView.filterButton.rx.tap.asSignal(),
            didSelectFilters: didSelectFiltersTrigger.asSignal()
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.filtersCount
            .drive(Binder(mainView.filterButton) { base, filtersCount in
                base.setup(count: filtersCount)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension AllProductsViewController {
    static func make() -> AllProductsViewController {
        let vc = AllProductsViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "AllProducts.Title".localized
        return vc
    }
}

// MARK: Private
private extension AllProductsViewController {
    func route(_ route: AllProductsViewModel.Route) {
        switch route {
        case .filter(let filters):
            let vc = ProductsFiltersViewController.make(selectedFilters: filters) { [weak self] filters in
                self?.didSelectFiltersTrigger.accept(filters)
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
