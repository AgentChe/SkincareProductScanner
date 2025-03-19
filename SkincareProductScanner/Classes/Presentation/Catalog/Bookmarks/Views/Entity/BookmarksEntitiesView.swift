//
//  BookmarksEntitiesView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 18.03.2025.
//

import UIKit
import RxCocoa

final class BookmarksEntitiesView: UIView {
    lazy var productsButton = makeButton(entity: .products)
    lazy var proceduresButton = makeButton(entity: .procedures)
    lazy var glossaryButton = makeButton(entity: .glossary)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension BookmarksEntitiesView {
    func setup(selected: BookmarksEntityButton.Entity) {
        productsButton.marked = productsButton.entity == selected
        proceduresButton.marked = proceduresButton.entity == selected
        glossaryButton.marked = glossaryButton.entity == selected
    }
    
    var didSelect: Signal<BookmarksEntityButton.Entity> {
        Signal<BookmarksEntityButton.Entity>
            .merge(
                productsButton.didTap,
                proceduresButton.didTap,
                glossaryButton.didTap
            )
    }
}

// MARK: Private
private extension BookmarksEntitiesView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension BookmarksEntitiesView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            productsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            productsButton.topAnchor.constraint(equalTo: topAnchor),
            productsButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            proceduresButton.leadingAnchor.constraint(equalTo: productsButton.trailingAnchor, constant: 16.scale),
            proceduresButton.topAnchor.constraint(equalTo: topAnchor),
            proceduresButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            glossaryButton.leadingAnchor.constraint(equalTo: proceduresButton.trailingAnchor, constant: 16.scale),
            glossaryButton.topAnchor.constraint(equalTo: topAnchor),
            glossaryButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension BookmarksEntitiesView {
    func makeButton(entity: BookmarksEntityButton.Entity) -> BookmarksEntityButton {
        let view = BookmarksEntityButton(entity: entity)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
