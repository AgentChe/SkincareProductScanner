//
//  ExploreHeaderView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 14.03.2025.
//

import UIKit

final class ExploreHeaderView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var menuButton = makeMenuButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ExploreHeaderView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension ExploreHeaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48.scale)
        ])
        
        NSLayoutConstraint.activate([
            menuButton.widthAnchor.constraint(equalToConstant: 24.scale),
            menuButton.heightAnchor.constraint(equalToConstant: 24.scale),
            menuButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            menuButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ExploreHeaderView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.bold(size: 22.scale))
            .lineHeight(34.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Explore.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeMenuButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Explore.Menu"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
