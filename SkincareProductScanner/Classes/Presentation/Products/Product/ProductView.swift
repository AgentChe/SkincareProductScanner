//
//  ProductView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 03.04.2025.
//

import UIKit

final class ProductView: UIView {
    lazy var headerView = makeHeaderView()
    lazy var tableView = makeTableView()
    lazy var favoriteButton = makeFavoriteButton()
    lazy var preloader = makePreloader()
    
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
private extension ProductView {
    func initialize() {
        backgroundColor = Appearance.main500
    }
}

// MARK: Make constraints
private extension ProductView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 379.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: favoriteButton.topAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            favoriteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            favoriteButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -14.scale),
            favoriteButton.heightAnchor.constraint(equalToConstant: 54.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ProductView {
    func makeHeaderView() -> ProductHeaderView {
        let view = ProductHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> ProductTableView {
        let view = ProductTableView()
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.contentInset = UIEdgeInsets(vertical: 8.scale)
        view.setContentOffset(CGPoint(x: 0, y: -8.scale), animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFavoriteButton() -> ProductFavoriteButton {
        let view = ProductFavoriteButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
