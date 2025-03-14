//
//  MenuTableCell.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 14.03.2025.
//

import UIKit

final class MenuTableCell: UITableViewCell {
    lazy var label = makeLabel()
    lazy var separator = makeSeparator()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Outfit.regular(size: 16.scale))
        .lineHeight(22.scale)
        .textAlignment(.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MenuTableCell {
    func setup(element: MenuTableElement) {
        label.attributedText = element.route.title.attributed(with: attrs)
        separator.isHidden = element.separatorHidden
    }
}

// MARK: Private
private extension MenuTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension MenuTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            separator.heightAnchor.constraint(equalToConstant: 1.scale),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension MenuTableCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main700
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

// MARK: Additional
private extension MenuTableElement.Route {
    var title: String {
        switch self {
        case .profileEntity(let menuTableProfileEntityElement):
            switch menuTableProfileEntityElement {
            case .skinType:
                return "Menu.SkinTypes".localized
            case .goals:
                return "Menu.Goals".localized
            case .preferences:
                return "Menu.Preferences".localized
            }
        case .info(let menuTableInfoElement):
            switch menuTableInfoElement {
            case .disclaimer:
                return "Menu.Disclaimer".localized
            case .references:
                return "Menu.References".localized
            }
        case .url(let menuTableURLElement):
            switch menuTableURLElement {
            case .termsOfUse:
                return "Menu.TermsOfUse".localized
            case .privacyPolicy:
                return "Menu.PrivacyPolicy".localized
            case .support:
                return "Menu.Support".localized
            }
        }
    }
}
