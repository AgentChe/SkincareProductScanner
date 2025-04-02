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
    lazy var tableView = makeTableView()
    lazy var centerPreloader = makePreloader()
    lazy var bottomPreloader = makePreloader()
    lazy var emptyView = makeEmptyView()
    
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
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            centerPreloader.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            centerPreloader.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomPreloader.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            bottomPreloader.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 11.scale),
            emptyView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -94.scale)
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
    
    func makeTableView() -> AllProductsTableView {
        let view = AllProductsTableView()
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.contentInset = UIEdgeInsets(vertical: 16.scale)
        view.setContentOffset(CGPoint(x: 0, y: -16.scale), animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 32.scale, height: 32.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmptyView() -> AllProductsEmptyView {
        let view = AllProductsEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
