//
//  ScanProductsViewController.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 31.03.2025.
//

import UIKit
import RxSwift

final class ScanProductsViewController: UIViewController {
    private lazy var mainView = ScanProductsView()
    
    private let viewModel: ScanProductsViewModel
    
    private let newSearch: () -> Void
    private let didClose: () -> Void
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var closeButton = TapAreaButton()
    
    private init(
        products: [Product],
        newSearch: @escaping () -> Void,
        didClose: @escaping () -> Void
    ) {
        self.viewModel = ScanProductsViewModel(products: products)
        self.newSearch = newSearch
        self.didClose = didClose
        
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
        
        let output = viewModel.configure(input: ScanProductsViewModel.Input(
            didTapClose: closeButton.rx.tap.asSignal(),
            didTapNewSearch: mainView.newSearchButton.rx.tap.asSignal(),
            didSelect: mainView.tableView.didSelect
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.isEmpty
            .drive(Binder(mainView) { base, isEmpty in
                base.setup(empty: isEmpty)
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        addCloseButton()
    }
}

// MARK: Public
extension ScanProductsViewController {
    static func make(
        products: [Product],
        newSearch: @escaping () -> Void,
        didClose: @escaping () -> Void
    ) -> ScanProductsViewController {
        let vc = ScanProductsViewController(
            products: products,
            newSearch: newSearch,
            didClose: didClose
        )
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = {
            products.isEmpty ? "ScanProducts.Title.Empty".localized : String(format: "ScanProducts.Title.Count".localized, products.count)
        }()
        return vc
    }
}

// MARK: Private
private extension ScanProductsViewController {
    func route(_ route: ScanProductsViewModel.Route) {
        switch route {
        case .close:
            didClose()
        case .newSearch:
            newSearch()
        case .product(let product):
            break // TODO
        }
    }
    
    func addCloseButton() {
        closeButton.backgroundColor = UIColor.clear
        closeButton.setImage(UIImage(named: "Close.Black"), for: .normal)
        
        let item = UIBarButtonItem(customView: closeButton)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 24.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 24.scale).isActive = true
        
        navigationItem.rightBarButtonItem = item
    }
}
