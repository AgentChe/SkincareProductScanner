//
//  MenuView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 14.03.2025.
//

import UIKit

final class MenuView: UIView {
    lazy var tableView = makeTableView()
    lazy var bottomInfoView = makeBottomInfoView()
    
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
private extension MenuView {
    func initialize() {
        backgroundColor = Appearance.main500
    }
}

// MARK: Make constraints
private extension MenuView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
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
private extension MenuView {
    func makeTableView() -> MenuTableView {
        let view = MenuTableView()
        view.backgroundColor = UIColor.clear
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(vertical: 24.scale)
        view.setContentOffset(CGPoint(x: 0, y: -24.scale), animated: false)
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
