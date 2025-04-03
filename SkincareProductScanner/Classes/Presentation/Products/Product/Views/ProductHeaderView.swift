//
//  ProductHeaderView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 03.04.2025.
//

import UIKit
import Kingfisher

final class ProductHeaderView: UIView {
    lazy var imageView = makeImageView()
    lazy var tabView = makeTabView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ProductHeaderView {
    func setup(image: URL) {
        imageView.kf.setImage(with: image)
    }
}

// MARK: Private
private extension ProductHeaderView {
    func initialize() {
        backgroundColor = Appearance.mono100
    }
}

// MARK: Make constraints
private extension ProductHeaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 180.scale),
            imageView.heightAnchor.constraint(equalToConstant: 180.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -81.scale)
        ])
        
        NSLayoutConstraint.activate([
            tabView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tabView.heightAnchor.constraint(equalToConstant: 54.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ProductHeaderView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTabView() -> ProductTabView {
        let view = ProductTabView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
