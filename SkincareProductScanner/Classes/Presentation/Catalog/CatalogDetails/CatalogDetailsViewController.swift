//
//  CatalogDetailsViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 23.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class CatalogDetailsViewController: UIViewController {
    enum Item {
        case glossary, procedure
    }
    
    private lazy var mainView = CatalogDetailsView()
    
    private lazy var viewModel = CatalogDetailsViewModel(item: item, catalog: catalog)
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var bookmarkButton = TapAreaButton()
    
    private lazy var didTapMarkedTrigger = PublishRelay<Bool>()
    
    private let item: Item
    private let catalog: Catalog
    
    private init(item: Item, catalog: Catalog) {
        self.item = item
        self.catalog = catalog
        
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
        
        let output = viewModel.configure(input: CatalogDetailsViewModel.Input(
            didTapMark: didTapMarkedTrigger.asSignal(),
            didTapDisclaimer: mainView.bottomInfoView.didTapDisclaimer,
            didTapReferences: mainView.bottomInfoView.didTapReferences
        ))
        
        let marked = output.marked
        
        bookmarkButton.rx.tap
            .withLatestFrom(marked)
            .bind(to: didTapMarkedTrigger)
            .disposed(by: disposeBag)
        
        marked
            .drive(Binder(self) { base, marked in
                base.update(marked: marked)
            })
            .disposed(by: disposeBag)
        
        output.sections
            .drive(Binder(mainView.tableView) { base, sections in
                base.setup(sections: sections)
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
        
        output.disposable
            .disposed(by: disposeBag)
        
        addBookmarkButton()
    }
}

// MARK: Public
extension CatalogDetailsViewController {
    static func make(item: Item, catalog: Catalog) -> CatalogDetailsViewController {
        let vc = CatalogDetailsViewController(item: item, catalog: catalog)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = catalog.name
        return vc
    }
}

// MARK: Private
private extension CatalogDetailsViewController {
    func addBookmarkButton() {
        bookmarkButton.backgroundColor = UIColor.clear
        
        let item = UIBarButtonItem(customView: bookmarkButton)
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
    
    func route(_ route: CatalogDetailsViewModel.Route) {
        switch route {
        case .paygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        case .disclaimer:
            let vc = DisclaimerViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .references:
            let vc = ReferencesViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func update(marked: Bool) {
        let image = UIImage(named: marked ? "CatalogDetails.Saved" : "CatalogDetails.Unsaved")
        bookmarkButton.setImage(image, for: .normal)
    }
}
