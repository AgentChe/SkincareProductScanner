//
//  SplashView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import UIKit

final class SplashView: UIView {
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var spinnerContainer = makeSpinnerContainer()
    lazy var spinner = makeSpinner()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension SplashView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
}

// MARK: Make constraints
private extension SplashView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 164.scale)
        ])
        
        NSLayoutConstraint.activate([
            spinnerContainer.widthAnchor.constraint(equalToConstant: 64.scale),
            spinnerContainer.heightAnchor.constraint(equalToConstant: 64.scale),
            spinnerContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinnerContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -127.scale)
        ])
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: spinnerContainer.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: spinnerContainer.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SplashView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.image = UIImage(named: "Splash.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.bold(size: 38.scale))
            .lineHeight(48.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Splash.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSpinnerContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 32.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSpinner() -> Spinner {
        let view = Spinner()
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        spinnerContainer.addSubview(view)
        return view
    }
}
