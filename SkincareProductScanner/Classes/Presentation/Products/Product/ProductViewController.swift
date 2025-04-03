//
//  ProductViewController.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 03.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class ProductViewController: UIViewController {
    private lazy var mainView = ProductView()
    
    private let viewModel: ProductViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var closeButton = TapAreaButton()
    
    private lazy var didTapFavoriteTrigger = PublishRelay<Bool>()
    
    private init(id: String) {
        viewModel = ProductViewModel(id: id)
        
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
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            self?.open(error: error) ?? .never()
        }
        
        let output = viewModel.configure(input: ProductViewModel.Input(
            didTapFavorite: didTapFavoriteTrigger.asSignal(),
            didTapClose: closeButton.rx.tap.asSignal(),
            didSelectTab: mainView.headerView.tabView.select,
            didSeletProduct: mainView.tableView.didSelectProduct
        ))
        
        let favorite = output.favorite
        
        mainView.favoriteButton.rx.tap
            .withLatestFrom(favorite)
            .bind(to: didTapFavoriteTrigger)
            .disposed(by: disposeBag)
        
        favorite
            .drive(Binder(mainView.favoriteButton) { base, favorite in
                base.setup(favorite: favorite)
            })
            .disposed(by: disposeBag)
        
        output.title
            .drive(Binder(self) { base, title in
                base.navigationItem.title = title
            })
            .disposed(by: disposeBag)
        
        output.image
            .drive(Binder(mainView.headerView) { base, image in
                base.setup(image: image)
            })
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.selectedTab
            .drive(Binder(mainView.headerView.tabView) { base, tab in
                base.setup(tab: tab)
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
extension ProductViewController {
    static func make(id: String) -> NavigationController {
        let vc = ProductViewController(id: id)
        vc.navigationItem.backButtonTitle = " "
        
        let nc = NavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        return nc
    }
}

// MARK: Private
private extension ProductViewController {
    func route(_ route: ProductViewModel.Route) {
        switch route {
        case .close:
            dismiss(animated: true)
        case .paygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        case .product(let product):
            let vc = ProductViewController.make(id: product.id)
            present(vc, animated: true)
        }
    }
    
    func activity(_ activity: Bool) {
        mainView.headerView.isHidden = activity
        mainView.tableView.isHidden = activity
        mainView.favoriteButton.isHidden = activity
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
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
