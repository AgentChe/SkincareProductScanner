//
//  ExploreCatalogButton.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 17.03.2025.
//

import UIKit

final class ExploreCatalogButton: UIButton {
    enum Catalog {
        case allProducts
        case procedures
        case glossary
    }
    
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    lazy var arrowView = makeArrowView()
    lazy var separator = makeSeparator()
    
    let catalog: Catalog
    
    private let withSeparator: Bool
    
    init(catalog: Catalog, withSeparator: Bool) {
        self.catalog = catalog
        self.withSeparator = withSeparator
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ExploreCatalogButton {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension ExploreCatalogButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 17.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17.scale)
        ])
        
        NSLayoutConstraint.activate([
            arrowView.widthAnchor.constraint(equalToConstant: 24.scale),
            arrowView.heightAnchor.constraint(equalToConstant: 24.scale),
            arrowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            arrowView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        if let separator {
            NSLayoutConstraint.activate([
                separator.leadingAnchor.constraint(equalTo: leadingAnchor),
                separator.trailingAnchor.constraint(equalTo: trailingAnchor),
                separator.bottomAnchor.constraint(equalTo: bottomAnchor),
                separator.heightAnchor.constraint(equalToConstant: 1.scale)
            ])
        }
    }
}

// MARK: Lazy initialization
private extension ExploreCatalogButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: catalog.iconName)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.medium(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = catalog.title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeArrowView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Explore.Catalogs.Arrow")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView? {
        guard withSeparator else { return nil }
        
        let view = UIView()
        view.backgroundColor = Appearance.main700
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension ExploreCatalogButton.Catalog {
    var iconName: String {
        switch self {
        case .allProducts:
            return "Explore.Catalogs.AllProducts"
        case .procedures:
            return "Explore.Catalogs.Procedures"
        case .glossary:
            return "Explore.Catalogs.Glossary"
        }
    }
    
    var title: String {
        switch self {
        case .allProducts:
            return "Explore.Catalogs.AllProducts".localized
        case .procedures:
            return "Explore.Catalogs.Procedures".localized
        case .glossary:
            return "Explore.Catalogs.Glossary".localized
        }
    }
}
