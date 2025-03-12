//
//  OTableCell.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 12.03.2025.
//

import UIKit

final class OTableCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var label = makeLabel()
    lazy var checkedView = makeCheckedView()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Outfit.medium(size: 18.scale))
        .lineHeight(28.scale)
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
extension OTableCell {
    func setup(element: OTableElement) {
        label.attributedText = element.name.attributed(with: attrs)
        
        let checkedIconName = element.marked ? "Onboarding.Check.T" : "Onboarding.Check.F"
        checkedView.image = UIImage(named: checkedIconName)
    }
}

// MARK: Private
private extension OTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension OTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -48.scale),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            checkedView.widthAnchor.constraint(equalToConstant: 24.scale),
            checkedView.heightAnchor.constraint(equalToConstant: 24.scale),
            checkedView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -18.scale),
            checkedView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OTableCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 12.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.main700.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeCheckedView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
