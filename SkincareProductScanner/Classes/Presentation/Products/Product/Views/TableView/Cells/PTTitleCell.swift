//
//  PTTitleCell.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 03.04.2025.
//

import UIKit

final class PTTitleCell: UITableViewCell {
    lazy var titleLabel = makeLabel()
    lazy var valueLabel = makeLabel()
    lazy var separator = makeSeparator()
    
    private lazy var titleAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Outfit.bold(size: 18.scale))
        .lineHeight(23.scale)
        .textAlignment(.left)
    private lazy var valueAttrs = TextAttributes()
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
extension PTTitleCell {
    func setup(element: PTTitleValueElement) {
        titleLabel.attributedText = element.title.attributed(with: titleAttrs)
        valueLabel.attributedText = element.value.attributed(with: valueAttrs)
    }
}

// MARK: Private
private extension PTTitleCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension PTTitleCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.scale),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PTTitleCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono200.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
