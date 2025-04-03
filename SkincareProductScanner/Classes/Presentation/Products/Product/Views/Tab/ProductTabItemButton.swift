//
//  ProductTabItemButton.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 03.04.2025.
//

import UIKit
import RxCocoa

final class ProductTabItemButton: UIButton {
    enum Tab {
        case overview, ingredients
    }
    
    lazy var marked: Bool = false {
        didSet {
            update()
        }
    }
    
    let tab: Tab
    
    lazy var label = makeLabel()
    lazy var separator = makeSeparator()
    
    private lazy var markedAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Outfit.bold(size: 16.scale))
        .lineHeight(22.scale)
        .textAlignment(.center)
    private lazy var normalAttrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.5))
        .font(Fonts.Outfit.regular(size: 16.scale))
        .lineHeight(22.scale)
        .textAlignment(.center)
    
    init(tab: Tab) {
        self.tab = tab
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ProductTabItemButton {
    var tap: Signal<Tab> {
        rx.tap
            .compactMap { [weak self] in self?.tab }
            .asSignal(onErrorSignalWith: .never())
    }
}

// MARK: Private
private extension ProductTabItemButton {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func update() {
        let attrs = marked ? markedAttrs : normalAttrs
        label.attributedText = tab.title.attributed(with: attrs)
        
        separator.isHidden = !marked
    }
}

// MARK: Make constraints
private extension ProductTabItemButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 2.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ProductTabItemButton {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main100
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension ProductTabItemButton.Tab {
    var title: String {
        switch self {
        case .overview:
            return "Product.Tab.Overview".localized
        case .ingredients:
            return "Product.Tab.Ingredients".localized
        }
    }
}
