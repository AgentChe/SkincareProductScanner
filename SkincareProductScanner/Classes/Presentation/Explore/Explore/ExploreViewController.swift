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
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            self?.open(error: error) ?? .never()
        }
        
        let output = viewModel.configure(input: ExploreViewModel.Input(
            didTapMenu: mainView.headerView.menuButton.rx.tap.asSignal(),
            didTapRecommendations: mainView.tableView.didTapSeeAllRecommendations,
            didSelectProduct: mainView.tableView.didSelectProduct,
            didTapCategories: mainView.tableView.didTapSeeAllCategories,
            didSelectCategory: mainView.tableView.didSelectCategory,
            didTapBookmarks: mainView.tableView.didTapBookmarks,
            didTapAllProducts: mainView.tableView.didTapAllProducts,
            didTapProcedures: mainView.tableView.didTapProcedures,
            didTapGlossary: mainView.tableView.didTapGlossary
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(mainView.preloader) { base, activity in
                activity ? base.startAnimating() : base.stopAnimating()
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
        case .recommendations:
            let vc = RecommendationsViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .product(let product):
            print("product") // TODO
        case .categories:
            let vc = CategoriesViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .category(let category):
            let vc = PresetsViewController.make(preset: category.name)
            navigationController?.pushViewController(vc, animated: true)
        case .bookmarks:
            let vc = BookmarksViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .allProducts:
            let vc = AllProductsViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .procedures:
            let vc = CatalogsViewController.make(item: .procedure)
            navigationController?.pushViewController(vc, animated: true)
        case .glossary:
            let vc = CatalogsViewController.make(item: .glossary)
            navigationController?.pushViewController(vc, animated: true)
        case .paygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        }
    }
    
    func open(error: Error) -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self else { return Disposables.create() }
                
                let vc = TryAgainViewController.make(error: error) {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}
