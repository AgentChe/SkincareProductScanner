//
//  CatalogsView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 17.03.2025.
//

import UIKit
import RxSwift

final class CatalogsView: UIView {
    lazy var searchField = makeSearchField()
    lazy var tableView = makeTableView()
    lazy var bottomInfoView = makeBottomInfoView()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CatalogsView {
    func initialize() {
        backgroundColor = Appearance.main500
        
        rx.keyboardHeight
            .bind(to: Binder(self) { base, keyboardHeight in
                let overlap = keyboardHeight - base.bottomInfoView.bounds.height
                let inset = max(16.scale, overlap)
                
                base.tableView.contentInset.bottom = inset
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make constraints
private extension CatalogsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            searchField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            searchField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            searchField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomInfoView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomInfoView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CatalogsView {
    func makeSearchField() -> CatalogsSearchField {
        let view = CatalogsSearchField()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> CatalogsTableView {
        let view = CatalogsTableView()
        view.contentInset = UIEdgeInsets(vertical: 10.scale)
        view.setContentOffset(CGPoint(x: 0, y: -10.scale), animated: false)
        view.separatorStyle = .singleLine
        view.separatorColor = Appearance.main700
        view.separatorInset = UIEdgeInsets(horizontal: 16.scale)
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBottomInfoView() -> BottomInfoView {
        let view = BottomInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
