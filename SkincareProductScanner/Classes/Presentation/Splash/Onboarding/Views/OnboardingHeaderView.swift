//
//  OnboardingHeaderView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 12.03.2025.
//

import UIKit

final class OnboardingHeaderView: UIView {
    var didTapBack: (() -> Void)?
    
    lazy var backButton = makeBackButton()
    lazy var progressView = makeProgressView()
    
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
extension OnboardingHeaderView {
    func setup(slide: OnboardingView.Slide) {
        isHidden = {
            switch slide {
            case .disclaimer:
                return true
            default:
                return false
            }
        }()
        
        progressView.progress = Float(slide.rawValue) / Float(OnboardingView.Slide.allCases.count)
    }
}

// MARK: Private
private extension OnboardingHeaderView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    @objc
    func backButtonTapped() {
        didTapBack?()
    }
}

// MARK: Make constraints
private extension OnboardingHeaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24.scale),
            backButton.heightAnchor.constraint(equalToConstant: 24.scale),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalToConstant: 123.scale),
            progressView.heightAnchor.constraint(equalToConstant: 6.scale),
            progressView.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OnboardingHeaderView {
    func makeBackButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Onboarding.Back"), for: .normal)
        view.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProgressView() -> UIProgressView {
        let view = UIProgressView()
        view.layer.cornerRadius = 3.scale
        view.layer.masksToBounds = true
        view.progressTintColor = Appearance.main100
        view.trackTintColor = Appearance.main200
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
