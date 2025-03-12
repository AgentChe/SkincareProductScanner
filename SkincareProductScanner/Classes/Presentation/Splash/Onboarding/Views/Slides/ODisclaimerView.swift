//
//  ODisclaimerView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 12.03.2025.
//

import UIKit

final class ODisclaimerView: UIView {
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var textLabel = makeTextLabel()
    lazy var nextButton = makeNextButton()
    
    private var didTapNext: () -> Void
    
    init(didTapNext: @escaping () -> Void) {
        self.didTapNext = didTapNext
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ODisclaimerView {
    func initialize() {
        backgroundColor = Appearance.main500
    }
    
    @objc
    func nextButtonTapped() {
        didTapNext()
    }
}

// MARK: Make constraints
private extension ODisclaimerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 486.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13.scale)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: 98.scale),
            nextButton.heightAnchor.constraint(equalToConstant: 54.scale),
            nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -14.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ODisclaimerView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Onboarding.Disclaimer")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.bold(size: 24.scale))
            .lineHeight(30.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Disclaimer.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextLabel() -> UILabel {
        let regularAttrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.regular(size: 18.scale))
            .lineHeight(23.scale)
            .textAlignment(.left)
        let boldAttrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.bold(size: 18.scale))
            .lineHeight(23.scale)
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
    
    func makeNextButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.medium(size: 18.scale))
        
        let view = UIButton()
        view.backgroundColor = Appearance.main700
        view.layer.cornerRadius = 12.scale
        view.setAttributedTitle("Next".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
