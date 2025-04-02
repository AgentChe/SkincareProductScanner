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
            didSelectFilters: didSelectFiltersTrigger.asSignal(),
            didChangedInputText: mainView.searchField.changedText,
            didTapSearch: mainView.searchField.didTapSearch,
            didSelectPreset: mainView.tableView.didSelectPreset,
            didSelectProduct: mainView.tableView.didSelectProduct,
            didScrollToBottom: mainView.tableView.didScrollToBottom
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
        
        output.sections
            .drive(Binder(mainView.tableView) { base, sections in
                base.setup(sections: sections)
            })
            .disposed(by: disposeBag)
        
        output.firstPageActivity
            .drive(Binder(mainView.centerPreloader) { base, activity in
                activity ? base.startAnimating() : base.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.paginationActivity
            .drive(Binder(mainView) { base, activity in
                base.tableView.contentInset.bottom = activity ? 48.scale : 16.scale
                activity ? base.bottomPreloader.startAnimating() : base.bottomPreloader.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.emptyViewHidden
            .drive(mainView.emptyView.rx.isHidden)
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
        case .preset(let preset):
            let vc = PresetsViewController.make(preset: preset)
            navigationController?.pushViewController(vc, animated: true)
        case .product(let product):
            break // TODO
        }
    }
}
