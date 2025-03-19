//
//  BookmarksEntityButton.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 18.03.2025.
//

import UIKit
import RxCocoa

final class BookmarksEntityButton: UIButton {
    enum Entity {
        case products, procedures, glossary
    }
    
    lazy var marked: Bool = false {
        didSet {
            update()
        }
    }
    
    let entity: Entity
    
    lazy var label = makeLabel()
    lazy var separator = makeSeparator()
    
    init(entity: Entity) {
        self.entity = entity
        
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
extension BookmarksEntityButton {
    var didTap: Signal<Entity> {
        rx.tap
            .compactMap { [weak self] in self?.entity }
            .asSignal(onErrorSignalWith: .never())
    }
}

// MARK: Private
private extension BookmarksEntityButton {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func update() {
        separator.isHidden = !marked
        label.alpha = marked ? 1 : 0.5
    }
}

// MARK: Make constraints
private extension BookmarksEntityButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.scale)
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
private extension BookmarksEntityButton {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.regular(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = entity.title.attributed(with: attrs)
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
private extension BookmarksEntityButton.Entity {
    var title: String {
        switch self {
        case .products:
            return "Bookmarks.Entity.Products".localized
        case .procedures:
            return "Bookmarks.Entity.Procedures".localized
        case .glossary:
            return "Bookmarks.Entity.Glossary".localized
        }
    }
}
