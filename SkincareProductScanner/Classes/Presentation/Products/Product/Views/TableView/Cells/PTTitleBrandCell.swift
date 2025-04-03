//
//  PTTitleBrandCell.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 03.04.2025.
//

import UIKit

final class PTTitleBrandCell: UITableViewCell {
    lazy var titleLabel = makeLabel()
    lazy var brandLabel = makeLabel()
    
    private lazy var titleAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Outfit.bold(size: 18.scale))
        .lineHeight(23.scale)
        .textAlignment(.left)
    private lazy var brandAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Outfit.medium(size: 18.scale))
        .lineHeight(23.scale)
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
extension PTTitleBrandCell {
    func setup(element: PTTitleBrandElement) {
        titleLabel.attributedText = element.title.attributed(with: titleAttrs)
        brandLabel.attributedText = element.brand.attributed(with: brandAttrs)
    }
}

// MARK: Private
private extension PTTitleBrandCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension PTTitleBrandCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            brandLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            brandLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            brandLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.scale),
            brandLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PTTitleBrandCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
