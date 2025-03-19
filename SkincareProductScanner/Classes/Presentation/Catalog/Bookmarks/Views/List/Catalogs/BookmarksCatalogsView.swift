//
//  BookmarksCatalogsView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 19.03.2025.
//

import UIKit

final class BookmarksCatalogsView: UIView {
    lazy var tableView = makeTableView()
    lazy var emptyView = makeEmptyView()
    lazy var preloader = makePreloader()
    lazy var bottomInfoView = makeBottomInfoView()
    
    private let entity: BookmarksCatalogsViewController.Entity
    
    init(entity: BookmarksCatalogsViewController.Entity) {
        self.entity = entity
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension BookmarksCatalogsView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension BookmarksCatalogsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomInfoView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: topAnchor, constant: 15.scale),
            emptyView.heightAnchor.constraint(equalToConstant: 528.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomInfoView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension BookmarksCatalogsView {
    func makeTableView() -> BookmarksCatalogsTableView {
        let view = BookmarksCatalogsTableView()
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.contentInset = UIEdgeInsets(vertical: 10.scale)
        view.setContentOffset(CGPoint(x: 0, y: -10.scale), animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmptyView() -> BookmarksEmptyView {
        let view = BookmarksEmptyView(entity: {
            switch entity {
            case .procedures:
                return .procedures
            case .glossary:
                return .glossary
            }
        }())
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 45.scale, height: 45.scale))
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
