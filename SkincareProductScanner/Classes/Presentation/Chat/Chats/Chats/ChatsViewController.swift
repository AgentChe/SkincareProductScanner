//
//  ChatsViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class ChatsViewController: UIViewController {
    private lazy var mainView = ChatsView()
    
    private lazy var viewModel = ChatsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didConfirmDeleteTrigger = PublishRelay<Chat>()
    
    private let didSelectChat: (Chat) -> Void
    
    private init(didSelectChat: @escaping (Chat) -> Void) {
        self.didSelectChat = didSelectChat
        
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
        
        let output = viewModel.configure(input: ChatsViewModel.Input(
            didWantDelete: mainView.tableView.didDelete,
            didConfirmDelete: didConfirmDeleteTrigger.asSignal(),
            selectChat: mainView.tableView.didSelect
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
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
    }
}

// MARK: Public
extension ChatsViewController {
    static func make(didSelectChat: @escaping (Chat) -> Void) -> ChatsViewController {
        let vc = ChatsViewController(didSelectChat: didSelectChat)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "Chats.Title".localized
        return vc
    }
}

// MARK: Private
private extension ChatsViewController {
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
    
    func route(_ route: ChatsViewModel.Route) {
        switch route {
        case .requestConfirmDelete(let chat):
            let vc = CDCViewController.make { [weak self] in
                self?.didConfirmDeleteTrigger.accept(chat)
            }
            present(vc, animated: false)
        case .chat(let chat):
            didSelectChat(chat)
            navigationController?.popViewController(animated: true)
        }
    }
}
