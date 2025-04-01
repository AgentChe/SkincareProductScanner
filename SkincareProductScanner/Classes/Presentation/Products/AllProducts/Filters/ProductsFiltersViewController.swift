//
//  ProductsFiltersViewController.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 01.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class ProductsFiltersViewController: UIViewController {
    private lazy var mainView = ProductsFiltersView()
    
    private let viewModel: ProductsFiltersViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didConfirmClearAllFiltersTrigger = PublishRelay<Void>()
    
    private let apply: (SelectedProductsFilters) -> Void
    
    private init(
        selectedFilters: SelectedProductsFilters,
        apply: @escaping (SelectedProductsFilters) -> Void
    ) {
        self.viewModel = ProductsFiltersViewModel(selectedFilters: selectedFilters)
        self.apply = apply
        
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
        
        let output = viewModel.configure(input: ProductsFiltersViewModel.Input(
            didTapItem: mainView.tableView.didTapItem,
            didTapClearAllFilters: mainView.clearAllFiltersButton.rx.tap.asSignal(),
            didConfirmClearAllFilters: didConfirmClearAllFiltersTrigger.asSignal(),
            didTapApplyFilters: mainView.applyFiltersButton.rx.tap.asSignal()
        ))
        
        output.sections
            .drive(Binder(mainView.tableView) { base, sections in
                base.setup(sections: sections)
            })
            .disposed(by: disposeBag)
        
        output.hasSelectedFilters
            .drive(Binder(mainView) { base, hasSelectedFilters in
                base.update(hasSelectedFilters: hasSelectedFilters)
            })
            .disposed(by: disposeBag)
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension ProductsFiltersViewController {
    static func make(
        selectedFilters: SelectedProductsFilters,
        apply: @escaping (SelectedProductsFilters) -> Void
    ) -> ProductsFiltersViewController {
        let vc = ProductsFiltersViewController(selectedFilters: selectedFilters, apply: apply)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "ProductsFilters.Title".localized
        return vc
    }
}

// MARK: Private
private extension ProductsFiltersViewController {
    func action(_ action: ProductsFiltersViewModel.Action) {
        switch action {
        case .confirmClearAllFilters:
            let vc = ConfirmClearFiltersController.make { [weak self] in
                self?.didConfirmClearAllFiltersTrigger.accept(Void())
            }
            present(vc, animated: false)
        case .apply(let filters):
            apply(filters)
            navigationController?.popViewController(animated: true)
        case .resetTableMarkedFilters:
            mainView.tableView.resetMarkedFilters()
        }
    }
}
