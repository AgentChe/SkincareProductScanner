//
//  BookmarksView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 18.03.2025.
//

import UIKit

final class BookmarksView: UIView {
    lazy var entitiesView = makeEntitiesView()
    lazy var contentContainer = makeContentContainer()
    
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
private extension BookmarksView {
    func initialize() {
        backgroundColor = Appearance.main500
    }
}

// MARK: Make constraints
private extension BookmarksView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            entitiesView.leadingAnchor.constraint(equalTo: leadingAnchor),
            entitiesView.trailingAnchor.constraint(equalTo: trailingAnchor),
            entitiesView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            contentContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentContainer.topAnchor.constraint(equalTo: entitiesView.bottomAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension BookmarksView {
    func makeEntitiesView() -> BookmarksEntitiesView {
        let view = BookmarksEntitiesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContentContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
