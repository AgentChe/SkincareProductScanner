//
//  OScanInfoView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 12.03.2025.
//

import UIKit

final class OScanInfoView: UIView {
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var nextButton = makeNextButton()
    lazy var disclaimerButton = makeDisclaimerButton()
    
    private var didTapNext: () -> Void
    private var didTapDisclaimer: () -> Void
    
    init(
        didTapNext: @escaping () -> Void,
        didTapDisclaimer: @escaping () -> Void
    ) {
        self.didTapNext = didTapNext
        self.didTapDisclaimer = didTapDisclaimer
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OScanInfoView {
    func initialize() {
        backgroundColor = Appearance.main500
    }
    
    @objc
    func nextButtonTapped() {
        didTapNext()
    }
    
    @objc
    func disclaimerButtonTapped() {
        didTapDisclaimer()
    }
}

// MARK: Make constraints
private extension OScanInfoView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 449.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: 98.scale),
            nextButton.heightAnchor.constraint(equalToConstant: 54.scale),
            nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: disclaimerButton.topAnchor, constant: -19.scale)
        ])
        
        NSLayoutConstraint.activate([
            disclaimerButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            disclaimerButton.heightAnchor.constraint(equalToConstant: 23.scale),
            disclaimerButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -19.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OScanInfoView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Onboarding.ScanInfo")
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
        view.numberOfLines = 0
        view.attributedText = "Onboarding.ScanInfo.Title".localized.attributed(with: attrs)
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
    
    func makeDisclaimerButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.4))
            .font(Fonts.Outfit.medium(size: 18.scale))
        
        let view = TapAreaButton()
        view.setAttributedTitle("Onboarding.DisclaimerInfo".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(disclaimerButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
