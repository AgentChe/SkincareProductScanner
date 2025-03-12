//
//  OnboardingDisclaimerView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 12.03.2025.
//

import UIKit

final class OnboardingDisclaimerView: UIView {
    lazy var dimmedView = makeDimmedView()
    lazy var thumbView = makeThumbView()
    lazy var container = makeContainer()
    lazy var titleLabel = makeTitleLabel()
    lazy var textLabel = makeTextLabel()
    lazy var button = makeButton()
    
    private lazy var containerYConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension OnboardingDisclaimerView {
    func animateShow() {
        containerYConstraint.isActive = false
        containerYConstraint = container.bottomAnchor.constraint(equalTo: bottomAnchor)
        containerYConstraint.isActive = true

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.dimmedView.alpha = 0.2
            self?.layoutIfNeeded()
        })
    }
    
    func animateDismiss(completion: @escaping (() -> Void)) {
        containerYConstraint.isActive = false
        containerYConstraint = container.topAnchor.constraint(equalTo: bottomAnchor, constant: 9.scale)
        containerYConstraint.isActive = true

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.dimmedView.alpha = 0
            self?.layoutIfNeeded()
        }, completion: { result in
            completion()
        })
    }
}

// MARK: Make Constraints
private extension OnboardingDisclaimerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            dimmedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dimmedView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            thumbView.widthAnchor.constraint(equalToConstant: 35.scale),
            thumbView.heightAnchor.constraint(equalToConstant: 5.scale),
            thumbView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            thumbView.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -4.scale)
        ])
        
        containerYConstraint = container.topAnchor.constraint(equalTo: bottomAnchor, constant: 9.scale)
        NSLayoutConstraint.activate([
            containerYConstraint,
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            textLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 121.scale),
            button.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -121.scale),
            button.heightAnchor.constraint(equalToConstant: 54.scale),
            button.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 30.scale),
            button.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -45.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OnboardingDisclaimerView {
    func makeDimmedView() -> UIView {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeThumbView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 2.5.scale
        view.backgroundColor = Appearance.main500
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main500
        view.layer.cornerRadius = 16.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.bold(size: 22.scale))
            .lineHeight(30.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Disclaimer.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeTextLabel() -> UILabel {
        let regularAttrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.regular(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.left)
        let boldAttrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.bold(size: 16.scale))
            .lineHeight(22.scale)
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
        container.addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.medium(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main700
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
