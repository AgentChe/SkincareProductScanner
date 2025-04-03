//
//  BookmarksProductsViewController.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 25.03.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class BookmarksProductsViewController: UIViewController {
    private lazy var mainView = BookmarksProductsView()
    
    private lazy var viewModel = BookmarksProductsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: BookmarksProductsViewModel.Input(
            didSelect: mainView.tableView.didSelect,
            didScrollToBottom: mainView.tableView.didScrollToBottom
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        Driver
            .combineLatest(output.isEmpty, output.firstPageActivity)
            .drive(Binder(mainView) { base, args in
                let (isEmpty, isLoading) = args
                
                isLoading ? base.centerPreloader.startAnimating() : base.centerPreloader.stopAnimating()
                
                base.emptyView.isHidden = isLoading || !isEmpty
                base.tableView.isHidden = isLoading || isEmpty
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
extension BookmarksProductsViewController {
    static func make() -> BookmarksProductsViewController {
        BookmarksProductsViewController()
    }
}

// MARK: Private
private extension BookmarksProductsViewController {
    func action(_ action: BookmarksProductsViewModel.Action) {
        switch action {
        case .openDetails(let product):
            let vc = ProductViewController.make(id: product.id)
            present(vc, animated: true)
        case .openPaygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        case .setup(let products):
            mainView.tableView.setup(elements: products)
        case .append(let products):
            mainView.tableView.append(elements: products)
        case .remove(let id):
            mainView.tableView.remove(id: id)
        }
    }
}
