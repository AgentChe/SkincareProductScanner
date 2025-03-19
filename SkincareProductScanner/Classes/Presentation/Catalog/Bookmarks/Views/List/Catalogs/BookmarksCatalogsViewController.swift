//
//  BookmarksCatalogsViewController.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 19.03.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class BookmarksCatalogsViewController: UIViewController {
    enum Entity {
        case procedures, glossary
    }
    
    private let mainView: BookmarksCatalogsView
    
    private let viewModel: BookmarksCatalogsViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private init(entity: Entity) {
        mainView = BookmarksCatalogsView(entity: entity)
        viewModel = BookmarksCatalogsViewModel(entity: entity)
        
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
            guard let self = self else {
                return .never()
            }
            
            return self.open(error: error)
        }
        
        let output = viewModel.configure(input: BookmarksCatalogsViewModel.Input(
            didTapDisclaimer: mainView.bottomInfoView.didTapDisclaimer,
            didTapReferences: mainView.bottomInfoView.didTapReferences,
            didSelect: mainView.tableView.didSelect
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
        
        Driver
            .combineLatest(output.isEmpty, output.isLoading)
            .drive(Binder(mainView) { base, args in
                let (isEmpty, isLoading) = args
                
                isLoading ? base.preloader.startAnimating() : base.preloader.stopAnimating()
                
                base.emptyView.isHidden = isLoading || !isEmpty
                base.bottomInfoView.isHidden = isLoading || isEmpty
                base.tableView.isHidden = isLoading || isEmpty
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension BookmarksCatalogsViewController {
    static func make(entity: Entity) -> BookmarksCatalogsViewController {
        BookmarksCatalogsViewController(entity: entity)
    }
}

// MARK: Private
private extension BookmarksCatalogsViewController {
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
    
    func route(_ route: BookmarksCatalogsViewModel.Route) {
        switch route {
        case .disclaimer:
            let vc = DisclaimerViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .references:
            let vc = ReferencesViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .paygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        case .procedure(let catalog):
            let vc = CatalogDetailsViewController.make(item: .procedure, catalog: catalog)
            navigationController?.pushViewController(vc, animated: true)
        case .glossary(let catalog):
            let vc = CatalogDetailsViewController.make(item: .glossary, catalog: catalog)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
