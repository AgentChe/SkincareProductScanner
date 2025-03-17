//
//  CatalogsViewController.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 17.03.2025.
//

import UIKit
import RxSwift

final class CatalogsViewController: UIViewController {
    enum Item {
        case glossary, procedure
    }
    
    private lazy var mainView = CatalogsView()
    
    private lazy var viewModel = CatalogsViewModel(item: item)
    
    private lazy var disposeBag = DisposeBag()
    
    private let item: Item
    
    private init(item: Item) {
        self.item = item
        
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
        
        let output = viewModel.configure(input: CatalogsViewModel.Input(
            didSearch: mainView.searchField.changedText,
            didSelect: mainView.tableView.didSelect,
            didTapDisclaimer: mainView.bottomInfoView.didTapDisclaimer,
            didTapReferences: mainView.bottomInfoView.didTapReferences
        ))
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
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
extension CatalogsViewController {
    static func make(item: Item) -> CatalogsViewController {
        let vc = CatalogsViewController(item: item)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = item.title
        return vc
    }
}

// MARK: Private
private extension CatalogsViewController {
    func route(_ route: CatalogsViewModel.Route) {
        switch route {
        case .glossaryDetails(let catalog):
            let vc = CatalogDetailsViewController.make(item: .glossary, catalog: catalog)
            navigationController?.pushViewController(vc, animated: true)
        case .procedureDetails(let catalog):
            let vc = CatalogDetailsViewController.make(item: .procedure, catalog: catalog)
            navigationController?.pushViewController(vc, animated: true)
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
}

// MARK: Additional
private extension CatalogsViewController.Item {
    var title: String {
        switch self {
        case .glossary:
            return "Catalogs.Glossaries.Title".localized
        case .procedure:
            return "Catalogs.Procedures.Title".localized
        }
    }
}

