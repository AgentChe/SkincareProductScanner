//
//  AllProductsView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 01.04.2025.
//

import UIKit

final class AllProductsView: UIView {
    lazy var searchField = makeSearchField()
    lazy var filterButton = makeFilterButton()
    
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
private extension AllProductsView {
    func initialize() {
        backgroundColor = Appearance.main500
    }
}

// MARK: Make constraints
private extension AllProductsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            searchField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            searchField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -76.scale),
            searchField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            filterButton.leadingAnchor.constraint(equalTo: searchField.trailingAnchor, constant: 8.scale),
            filterButton.topAnchor.constraint(equalTo: searchField.topAnchor),
            filterButton.bottomAnchor.constraint(equalTo: searchField.bottomAnchor),
            filterButton.heightAnchor.constraint(equalTo: filterButton.widthAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension AllProductsView {
    func makeSearchField() -> AllProductsSearchField {
        let view = AllProductsSearchField()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFilterButton() -> AllProductsFilterButton {
        let view = AllProductsFilterButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
