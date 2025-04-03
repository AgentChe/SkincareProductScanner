//
//  ProductTabView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 03.04.2025.
//

import UIKit
import RxCocoa

final class ProductTabView: UIView {
    lazy var overviewButton = makeTabItemButton(tab: .overview)
    lazy var ingredientsButton = makeTabItemButton(tab: .ingredients)
    
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
extension ProductTabView {
    func setup(tab: ProductTabItemButton.Tab) {
        overviewButton.marked = tab == overviewButton.tab
        ingredientsButton.marked = tab == ingredientsButton.tab
    }
    
    var select: Signal<ProductTabItemButton.Tab> {
        Signal
            .merge(
                overviewButton.tap,
                ingredientsButton.tap
            )
    }
}

// MARK: Private
private extension ProductTabView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension ProductTabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            overviewButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            overviewButton.trailingAnchor.constraint(equalTo: centerXAnchor),
            overviewButton.topAnchor.constraint(equalTo: topAnchor),
            overviewButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            ingredientsButton.leadingAnchor.constraint(equalTo: centerXAnchor),
            ingredientsButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            ingredientsButton.topAnchor.constraint(equalTo: topAnchor),
            ingredientsButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ProductTabView {
    func makeTabItemButton(tab: ProductTabItemButton.Tab) -> ProductTabItemButton {
        let view = ProductTabItemButton(tab: tab)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
