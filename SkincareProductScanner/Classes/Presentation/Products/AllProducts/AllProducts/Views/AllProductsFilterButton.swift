//
//  AllProductsFilterButton.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 01.04.2025.
//

import UIKit

final class AllProductsFilterButton: UIButton {
    lazy var circleView = makeCircleView()
    lazy var iconView = makeIconView()
    lazy var countLabel = makeCountLabel()
    
    private lazy var countAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Outfit.medium(size: 14.scale))
        .textAlignment(.center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        setup(count: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2
        circleView.layer.cornerRadius = bounds.width / 2
    }
}

// MARK: Public
extension AllProductsFilterButton {
    func setup(count: Int) {
        countLabel.isHidden = count == 0
        countLabel.attributedText = String(count).attributed(with: countAttrs)
    }
}

// MARK: Private
private extension AllProductsFilterButton {
    func initialize() {
        backgroundColor = UIColor.clear
        layer.masksToBounds = false
    }
}

// MARK: Make constraints
private extension AllProductsFilterButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            circleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            circleView.trailingAnchor.constraint(equalTo: trailingAnchor),
            circleView.topAnchor.constraint(equalTo: topAnchor),
            circleView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            countLabel.widthAnchor.constraint(equalToConstant: 18.scale),
            countLabel.heightAnchor.constraint(equalToConstant: 18.scale),
            countLabel.topAnchor.constraint(equalTo: topAnchor, constant: -5.scale),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension AllProductsFilterButton {
    func makeCircleView() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = Appearance.mono100
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.main700.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "AllProducts.Filter")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCountLabel() -> UILabel {
        let view = UILabel()
        view.backgroundColor = Appearance.main100
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 9.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
