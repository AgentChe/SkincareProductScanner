//
//  ScanImageResizeOptionsView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 31.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class ScanImageResizeOptionsView: UIView {
    enum State {
        case acceptPhoto
        case preloader
        case incorrect
    }
    
    private lazy var whiteButtonAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Outfit.medium(size: 18.scale))
    private lazy var textAttrs = TextAttributes()
        .textColor(Appearance.mono100.withAlphaComponent(0.8))
        .font(Fonts.Outfit.medium(size: 14.scale))
        .lineHeight(20.scale)
        .textAlignment(.center)
    
    private lazy var didAcceptPhotoTrigger = PublishRelay<Void>()
    private lazy var didRetakePhotoTrigger = PublishRelay<Void>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ScanImageResizeOptionsView {
    func setup(state: State) {
        subviews.forEach { $0.removeFromSuperview() }
        buildUI(state: state)
        layoutIfNeeded()
    }
    
    var didAcceptPhoto: Signal<Void> {
        didAcceptPhotoTrigger.asSignal()
    }
    
    var didRetakePhoto: Signal<Void> {
        didRetakePhotoTrigger.asSignal()
    }
}

// MARK: Private
private extension ScanImageResizeOptionsView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func buildUI(state: State) {
        switch state {
        case .acceptPhoto:
            buildAcceptPhotoUI()
        case .preloader:
            buildPreloaderUI()
        case .incorrect:
            buildIncorrectUI()
        }
    }
    
    func buildAcceptPhotoUI() {
        let label = UILabel()
        label.attributedText = "ScanImageResize.AcceptPhoto".localized.attributed(with: textAttrs)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        let acceptButton = TapAreaButton()
        acceptButton.setImage(UIImage(named: "ScanImageResize.Accept"), for: .normal)
        acceptButton.backgroundColor = UIColor.clear
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.addTarget(self, action: #selector(acceptTapped), for: .touchUpInside)
        addSubview(acceptButton)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.bottomAnchor.constraint(equalTo: acceptButton.topAnchor, constant: -30.scale)
        ])
        
        NSLayoutConstraint.activate([
            acceptButton.widthAnchor.constraint(equalToConstant: 72.scale),
            acceptButton.heightAnchor.constraint(equalToConstant: 72.scale),
            acceptButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            acceptButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -19.scale)
        ])
    }
    
    func buildPreloaderUI() {
        let label = UILabel()
        label.attributedText = "ScanImageResize.Preloader".localized.attributed(with: textAttrs)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        let preloader = Spinner(
            size: CGSize(width: 72.scale, height: 72.scale),
            style: .scan
        )
        preloader.startAnimating()
        preloader.translatesAutoresizingMaskIntoConstraints = false
        addSubview(preloader)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.bottomAnchor.constraint(equalTo: preloader.topAnchor, constant: -30.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -19.scale)
        ])
    }
    
    func buildIncorrectUI() {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.image = UIImage(named: "ScanImageResize.Incorrect")
        iconView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(iconView)
        
        let label = UILabel()
        label.attributedText = "ScanImageResize.Incorrect".localized.attributed(with: textAttrs)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        let retakeButton = UIButton()
        retakeButton.setAttributedTitle("ScanImageResize.RetakePhoto".localized.attributed(with: whiteButtonAttrs), for: .normal)
        retakeButton.backgroundColor = Appearance.main100
        retakeButton.layer.cornerRadius = 16.scale
        retakeButton.translatesAutoresizingMaskIntoConstraints = false
        retakeButton.addTarget(self, action: #selector(retakeTapped), for: .touchUpInside)
        addSubview(retakeButton)
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.topAnchor.constraint(equalTo: topAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 26.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 14.scale),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -14.scale)
        ])
        
        NSLayoutConstraint.activate([
            retakeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            retakeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            retakeButton.heightAnchor.constraint(equalToConstant: 54.scale),
            retakeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14.scale)
        ])
    }
    
    @objc
    func acceptTapped() {
        didAcceptPhotoTrigger.accept(Void())
    }
    
    @objc
    func retakeTapped() {
        didRetakePhotoTrigger.accept(Void())
    }
}
