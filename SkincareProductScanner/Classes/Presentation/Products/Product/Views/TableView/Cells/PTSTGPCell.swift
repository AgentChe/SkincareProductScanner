//
//  PTSTGPCell.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 03.04.2025.
//

import UIKit

final class PTSTGPCell: UITableViewCell {
    lazy var iconView = makeIconView()
    lazy var titleLabel = makeTitleLabel()
    lazy var collectionView = makeCollectionView()
    lazy var separator = makeSeparator()
    
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
private extension PTSTGPCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension PTSTGPCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 12.scale),
            iconView.heightAnchor.constraint(equalToConstant: 12.scale),
            iconView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -5.scale),
            iconView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 33.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.scale),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24.scale),
            collectionView.heightAnchor.constraint(equalToConstant: 62.scale)
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
private extension PTSTGPCell {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Product.TailoredForYou")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.6))
            .font(Fonts.Outfit.regular(size: 14.scale))
            .lineHeight(20.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Product.TailoredForYou".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeCollectionView() -> ETSTGPCollectionView {
        let layout = ETSTGPCollectionLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10.scale
        layout.minimumInteritemSpacing = 10.scale
        
        let view = ETSTGPCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsHorizontalScrollIndicator = false
        view.contentInset = UIEdgeInsets(horizontal: 16.scale)
        view.setContentOffset(CGPoint(x: 16.scale, y: 0), animated: false)
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
