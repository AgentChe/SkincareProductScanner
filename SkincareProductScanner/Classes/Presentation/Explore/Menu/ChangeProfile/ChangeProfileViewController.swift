//
//  ChangeProfileViewController.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 14.03.2025.
//

import UIKit
import RxSwift

final class ChangeProfileViewController: UIViewController {
    enum Field {
        case skinTypes
        case goals
        case preferences
    }
    
    private let mainView: ChangeProfileFieldView
    
    private lazy var viewModel = ChangeProfileViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private init(field: Field) {
        mainView = {
            switch field {
            case .skinTypes:
                return ChangeSkinTypesView()
            case .goals:
                return ChangeGoalsView()
            case .preferences:
                return ChangePreferencesView()
            }
        }()
        
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
        
        let output = viewModel.configure(input: ChangeProfileViewModel.Input(
            changedField: mainView.changedField
        ))
        
        output.activity
            .drive(Binder(mainView) { base, activity in
                base.activity(activity)
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
extension ChangeProfileViewController {
    static func make(field: Field) -> ChangeProfileViewController {
        let vc = ChangeProfileViewController(field: field)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = {
            switch field {
            case .skinTypes:
                return "ChangeProfile.Title.SkinTypes".localized
            case .goals:
                return "ChangeProfile.Title.Goals".localized
            case .preferences:
                return "ChangeProfile.Title.Preferences".localized
            }
        }()
        return vc
    }
}

// MARK: Private
private extension ChangeProfileViewController {
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
    
    func route(_ route: ChangeProfileViewModel.Route) {
        switch route {
        case .close:
            navigationController?.popViewController(animated: true)
        }
    }
}
