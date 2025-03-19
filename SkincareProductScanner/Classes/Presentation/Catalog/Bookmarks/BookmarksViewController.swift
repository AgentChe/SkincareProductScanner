//
//  BookmarksViewController.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 18.03.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class BookmarksViewController: UIViewController {
    private lazy var mainView = BookmarksView()
    
    private lazy var viewModel = BookmarksViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var coordinator = BookmarksCoordinator(
        parentVC: self,
        container: mainView.contentContainer
    )
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: BookmarksViewModel.Input(
            didSelectEntity: mainView.entitiesView.didSelect
        ))
        
        let currentEntity = output.currentEntity
        
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(currentEntity)
            .drive(Binder(self) { base, entity in
                base.change(entity: entity)
            })
            .disposed(by: disposeBag)
        
        currentEntity
            .skip(1)
            .drive(Binder(self) { base, entity in
                base.change(entity: entity)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension BookmarksViewController {
    static func make() -> BookmarksViewController {
        let vc = BookmarksViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "Bookmarks.Title".localized
        return vc
    }
}

// MARK: Private
private extension BookmarksViewController {
    func change(entity: BookmarksEntityButton.Entity) {
        mainView.entitiesView.setup(selected: entity)
        coordinator.change(entity: entity)
    }
}
