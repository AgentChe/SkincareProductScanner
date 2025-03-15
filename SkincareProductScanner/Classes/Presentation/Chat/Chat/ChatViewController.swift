//
//  ChatViewController.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

import UIKit
import RxSwift
import RxCocoa
import Toast_Swift

final class ChatViewController: UIViewController {
    private lazy var mainView = ChatView()
    
    private lazy var viewModel = ChatViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didSelectChatFromHistoryTrigger = PublishRelay<Chat>()
    
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
        
        mainView.tableView
            .didChangeElementsCount
            .emit(to: Binder(mainView) { base, count in
                base.startNewChatButton.isHidden = (count == 0)
                base.placeholderView.isHidden = (count > 0)
                base.tableView.isHidden = (count == 0)
            })
            .disposed(by: disposeBag)
        
        let didSendMessage = mainView.inputField
            .sendButton.rx.tap
            .withLatestFrom(mainView.inputField.textField.rx.text)
            .compactMap { message -> ChatViewModel.DataForSendMessage? in
                guard let message, !message.isEmpty else { return nil }
                return (nil, message)
            }
            .asSignal(onErrorSignalWith: .never())
        let didTapRegenerate = mainView.regenerateView
            .regenerateButton.rx.tap.asSignal()
            .withLatestFrom(didSendMessage)
        
        let output = viewModel.configure(input: ChatViewModel.Input(
            didTapHistory: mainView.historyButton.rx.tap.asSignal(),
            didSelectChatFromHistory: didSelectChatFromHistoryTrigger.asSignal(),
            didStartNewChat: mainView.startNewChatButton.rx.tap.asSignal(),
            didScrollToTop: mainView.tableView.didScrollToTop,
            didSendMessage: didSendMessage,
            didTapRegenerate: didTapRegenerate,
            didTapCopy: mainView.tableView.didCopy,
            didTapRefresh: mainView.tableView.didRefresh,
            didTapDisclaimer: mainView.placeholderView.bottomInfoView.didTapDisclaimer,
            didTapReferences: mainView.placeholderView.bottomInfoView.didTapReferences,
            inputFocusChanged: mainView.inputField.focusChanged
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.disclaimerHidden
            .drive(Binder(mainView.placeholderView) { base, hidden in
                base.separator.isHidden = hidden
                base.bottomInfoView.isHidden = hidden
            })
            .disposed(by: disposeBag)
        
        addHideKeyboardAction()
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
extension ChatViewController {
    static func make() -> ChatViewController {
        let vc = ChatViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension ChatViewController {
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
    
    func route(_ route: ChatViewModel.Route) {
        switch route {
        case .history:
            let vc = ChatsViewController.make { [weak self] chat in
                self?.didSelectChatFromHistoryTrigger.accept(chat)
            }
            navigationController?.pushViewController(vc, animated: true)
        case .disclaimer:
            let vc = DisclaimerViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .references:
            let vc = ReferencesViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func action(_ action: ChatViewModel.Action) {
        switch action {
        case .reset:
            mainView.tableView.reset()
        case .insertPage(let elements):
            mainView.tableView.insert(elements: elements)
        case .add(let elements):
            mainView.tableView.add(elements: elements)
        case .removeAnswer(let messageId):
            mainView.tableView.remove(answer: messageId)
        case .startWaiting:
            mainView.tableView.loading(waitAnswer: true)
        case .stopWaiting:
            mainView.tableView.loading(waitAnswer: false)
        case .changeInput(let input):
            mainView.inputField.isHidden = (input != .questionInput)
            mainView.regenerateView.isHidden = (input != .regenerateLastQuestion)
        case .clearInput:
            mainView.inputField.textField.text = ""
        case .copy(let text):
            UIPasteboard.general.string = text
            
            mainView.makeToast("Chat.Copied.Toast".localized)
        case .lockSendMessage(let lock):
            mainView.inputField.sendButton.isEnabled = !lock
        }
    }
    
    func addHideKeyboardAction() {
         let tapGesture = UITapGestureRecognizer()
         tapGesture.cancelsTouchesInView = true
         mainView.addGestureRecognizer(tapGesture)
         
         tapGesture.rx.event
             .bind(to: Binder(mainView) { base, event in
                 base.endEditing(true)
             })
             .disposed(by: disposeBag)
     }
}
