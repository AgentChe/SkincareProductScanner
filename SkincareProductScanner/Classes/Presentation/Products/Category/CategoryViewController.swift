//
//  CategoryViewController.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 26.03.2025.
//

import UIKit
import RxSwift

final class CategoryViewController: UIViewController {
    private lazy var mainView = CategoryView()
    
    private let viewModel: CategoryViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private init(category: ProductCategory) {
        viewModel = CategoryViewModel(category: category)
        
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
        
        let output = viewModel.configure(input: CategoryViewModel.Input(
            didSelect: mainView.tableView.didSelect,
            didScrollToBottom: mainView.tableView.didScrollToBottom
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.firstPageActivity
            .drive(Binder(mainView.centerPreloader) { base, activity in
                activity ? base.startAnimating() : base.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.paginationActivity
            .drive(Binder(mainView) { base, activity in
                base.tableView.contentInset.bottom = activity ? 48.scale : 8.scale
                activity ? base.bottomPreloader.startAnimating() : base.bottomPreloader.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension CategoryViewController {
    static func make(category: ProductCategory) -> CategoryViewController {
        let vc = CategoryViewController(category: category)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = category.name
        return vc
    }
}

// MARK: Private
private extension CategoryViewController {
    func action(_ action: CategoryViewModel.Action) {
        switch action {
        case .openDetails(let product):
            break // TODO
        case .setup(let products):
            mainView.tableView.setup(elements: products)
        case .append(let products):
            mainView.tableView.append(elements: products)
        }
    }
}
