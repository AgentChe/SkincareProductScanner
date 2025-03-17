//
//  ExploreTableCatalogsCell.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 17.03.2025.
//

import UIKit

final class ExploreTableCatalogsCell: UITableViewCell {
    var didTapAllProducts: (() -> Void)?
    var didTapProcedures: (() -> Void)?
    var didTapGlossary: (() -> Void)?
    
    lazy var container = makeContainer()
    lazy var allProductsButton = makeActionButton(catalog: .allProducts, withSeparator: true)
    lazy var proceduresButton = makeActionButton(catalog: .procedures, withSeparator: true)
    lazy var glossaryButton = makeActionButton(catalog: .glossary, withSeparator: false)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ExploreTableCatalogsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func didTap(sender: UIButton) {
        if sender === allProductsButton {
            didTapAllProducts?()
        } else if sender === proceduresButton {
            didTapProcedures?()
        } else if sender === glossaryButton {
            didTapGlossary?()
        }
    }
}

// MARK: Make constraints
private extension ExploreTableCatalogsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            allProductsButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            allProductsButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            allProductsButton.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            proceduresButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            proceduresButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            proceduresButton.topAnchor.constraint(equalTo: allProductsButton.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            glossaryButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            glossaryButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            glossaryButton.topAnchor.constraint(equalTo: proceduresButton.bottomAnchor),
            glossaryButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ExploreTableCatalogsCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 16.scale
        view.layer.shadowColor = Appearance.main700.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2.scale)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeActionButton(catalog: ExploreCatalogButton.Catalog, withSeparator: Bool) -> ExploreCatalogButton {
        let view = ExploreCatalogButton(catalog: catalog, withSeparator: withSeparator)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didTap(sender:)), for: .touchUpInside)
        container.addSubview(view)
        return view
    }
}
