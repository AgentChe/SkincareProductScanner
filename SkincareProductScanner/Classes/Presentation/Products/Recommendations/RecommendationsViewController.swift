//
//  RecommendationsViewController.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 25.03.2025.
//

import UIKit
import RxSwift

final class RecommendationsViewController: UIViewController {
    private lazy var mainView = RecommendationsView()
    
    private lazy var viewModel = RecommendationsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: RecommendationsViewModel.Input(
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
extension RecommendationsViewController {
    static func make() -> RecommendationsViewController {
        let vc = RecommendationsViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "Recommendations.Title".localized
        return vc
    }
}

// MARK: Private
private extension RecommendationsViewController {
    func action(_ action: RecommendationsViewModel.Action) {
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
        }
    }
}
