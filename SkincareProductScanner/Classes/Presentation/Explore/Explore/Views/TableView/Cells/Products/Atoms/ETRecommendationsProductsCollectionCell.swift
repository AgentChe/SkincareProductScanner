//
//  ETRecommendationsProductsCollectionCell.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 25.03.2025.
//

import UIKit
import Kingfisher

final class ETRecommendationsProductsCollectionCell: UICollectionViewCell {
    lazy var imageContainer = makeImageContainer()
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeLabel()
    lazy var brandLabel = makeLabel()
    
    private lazy var titleAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Outfit.bold(size: 18.scale))
        .lineHeight(23.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    private lazy var brandAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Outfit.regular(size: 16.scale))
        .lineHeight(22.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
}

// MARK: Public
extension ETRecommendationsProductsCollectionCell {
    func setup(element: Product) {
        imageView.kf.setImage(with: element.image)
        titleLabel.attributedText = element.title.attributed(with: titleAttrs)
        brandLabel.attributedText = element.brand.attributed(with: brandAttrs)
    }
}

// MARK: Private
private extension ETRecommendationsProductsCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension ETRecommendationsProductsCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageContainer.heightAnchor.constraint(equalToConstant: 164.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.scale),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            brandLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.scale),
            brandLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.scale),
            brandLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ETRecommendationsProductsCollectionCell {
    func makeImageContainer() -> UIView {
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
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
