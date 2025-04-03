//
//  ProductFavoriteButton.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 03.04.2025.
//

import UIKit

final class ProductFavoriteButton: UIButton {
    private lazy var favoriteAttrs = TextAttributes()
        .textColor(Appearance.main300)
        .font(Fonts.Outfit.medium(size: 18.scale))
    private lazy var notFavoriteAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Outfit.medium(size: 18.scale))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ProductFavoriteButton {
    func setup(favorite: Bool) {
        let attrs = favorite ? favoriteAttrs : notFavoriteAttrs
        let title = "Product.Favorite.\(favorite ? "T" : "F")".localized
        setAttributedTitle(title.attributed(with: attrs), for: .normal)
        
        backgroundColor = favorite ? Appearance.main400 : Appearance.main100
    }
}

// MARK: Private
private extension ProductFavoriteButton {
    func initialize() {
        layer.cornerRadius = 16.scale
    }
}
