//
//  CategoriesViewController.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 26.03.2025.
//

import UIKit
import RxSwift

final class CategoriesViewController: UIViewController {
    private lazy var mainView = CategoriesView()
    
    private lazy var viewModel = CategoriesViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            self?.open(error: error) ?? .never()
        }
        
        let output = viewModel.configure(input: CategoriesViewModel.Input(
            didSelectCategory: mainView.tableView.didSelect
        ))
        
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
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension CategoriesViewController {
    static func make() -> CategoriesViewController {
        let vc = CategoriesViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "Categories.Title".localized
        return vc
    }
}

// MARK: Private
private extension CategoriesViewController {
    func route(_ route: CategoriesViewModel.Route) {
        switch route {
        case .category(let category):
            let vc = PresetsViewController.make(preset: category.name)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func open(error: Error) -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make(error: error) {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}
