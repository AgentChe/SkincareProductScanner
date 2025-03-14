//
//  DisclaimerView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 14.03.2025.
//

import UIKit

final class DisclaimerView: UIView {
    lazy var label = makeLabel()
    
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
private extension DisclaimerView {
    func initialize() {
        backgroundColor = Appearance.main500
    }
}

// MARK: Make constraints
private extension DisclaimerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension DisclaimerView {
    func makeLabel() -> UILabel {
        let regularAttrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.regular(size: 16.scale))
            .lineHeight(19.scale)
            .textAlignment(.left)
        let boldAttrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.bold(size: 16.scale))
            .lineHeight(19.scale)
            .textAlignment(.left)
        
        let string = NSMutableAttributedString()
        string.append("Disclaimer.Text.1".localized.attributed(with: regularAttrs))
        string.append("Disclaimer.Text.2".localized.attributed(with: boldAttrs))
        string.append("Disclaimer.Text.3".localized.attributed(with: regularAttrs))
        string.append("Disclaimer.Text.4".localized.attributed(with: boldAttrs))
        string.append("Disclaimer.Text.5".localized.attributed(with: regularAttrs))
        
        let view = UILabel()
        view.attributedText = string
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
