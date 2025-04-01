//
//  ConfirmClearFiltersController.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 01.04.2025.
//

import UIKit
import RxSwift

final class ConfirmClearFiltersController: UIViewController {
    private lazy var mainView = ConfirmClearFiltersView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let clearAll: () -> Void
    
    private init(clearAll: @escaping () -> Void) {
        self.clearAll = clearAll
        
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
        
        mainView.cancelButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss()
            })
            .disposed(by: disposeBag)
        
        mainView.clearAllButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss {
                    base.clearAll()
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        mainView.animateShow()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        dismiss()
    }
}

// MARK: Public
extension ConfirmClearFiltersController {
    static func make(clearAll: @escaping () -> Void) -> ConfirmClearFiltersController {
        let vc = ConfirmClearFiltersController(clearAll: clearAll)
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}

// MARK: Private
private extension ConfirmClearFiltersController {
    func dismiss(completion: (() -> Void)? = nil) {
        mainView.animateDismiss { [weak self] in
            self?.dismiss(animated: false) {
                completion?()
            }
        }
    }
}
