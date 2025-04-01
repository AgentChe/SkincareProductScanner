//
//  PresetsViewController.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 26.03.2025.
//

import UIKit
import RxSwift

final class PresetsViewController: UIViewController {
    private lazy var mainView = PresetsView()
    
    private let viewModel: PresetsViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private init(preset: String) {
        viewModel = PresetsViewModel(preset: preset)
        
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
        
        let output = viewModel.configure(input: PresetsViewModel.Input(
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
extension PresetsViewController {
    static func make(preset: String) -> PresetsViewController {
        let vc = PresetsViewController(preset: preset)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = preset
        return vc
    }
}

// MARK: Private
private extension PresetsViewController {
    func action(_ action: PresetsViewModel.Action) {
        switch action {
        case .openDetails(let product):
            break // TODO
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
