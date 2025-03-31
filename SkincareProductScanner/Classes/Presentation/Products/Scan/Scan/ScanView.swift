//
//  ScanView.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 12.09.2024.
//

import UIKit

final class ScanView: UIView {
    lazy var placeholderView = makePlaceholderView()
    lazy var wallpapersButton = makeTapAreaButton(imageName: "Scan.Wallpapers")
    lazy var takeButton = makeTapAreaButton(imageName: "Scan.Take")
    lazy var flashButton = makeTapAreaButton(imageName: "Scan.Flash")
    lazy var permissionProblemView = makePermissionProblemView()
    lazy var placeholderLabel = makePlaceholderLabel()
    
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
private extension ScanView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension ScanView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            placeholderView.widthAnchor.constraint(equalToConstant: 330.scale),
            placeholderView.heightAnchor.constraint(equalToConstant: 467.scale),
            placeholderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderView.topAnchor.constraint(equalTo: topAnchor, constant: 138.scale)
        ])
        
        NSLayoutConstraint.activate([
            wallpapersButton.widthAnchor.constraint(equalToConstant: 46.scale),
            wallpapersButton.heightAnchor.constraint(equalToConstant: 46.scale),
            wallpapersButton.trailingAnchor.constraint(equalTo: takeButton.leadingAnchor, constant: -58.scale),
            wallpapersButton.centerYAnchor.constraint(equalTo: takeButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            takeButton.widthAnchor.constraint(equalToConstant: 72.scale),
            takeButton.heightAnchor.constraint(equalToConstant: 72.scale),
            takeButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            takeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -26.scale)
        ])
        
        NSLayoutConstraint.activate([
            flashButton.widthAnchor.constraint(equalToConstant: 46.scale),
            flashButton.heightAnchor.constraint(equalToConstant: 46.scale),
            flashButton.leadingAnchor.constraint(equalTo: takeButton.trailingAnchor, constant: 58.scale),
            flashButton.centerYAnchor.constraint(equalTo: takeButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            permissionProblemView.leadingAnchor.constraint(equalTo: leadingAnchor),
            permissionProblemView.trailingAnchor.constraint(equalTo: trailingAnchor),
            permissionProblemView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderLabel.bottomAnchor.constraint(equalTo: takeButton.topAnchor, constant: -19.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ScanView {
    func makePlaceholderView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Scan.Placeholder")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTapAreaButton(imageName: String) -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: imageName), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePermissionProblemView() -> ScanPermissionProblemView {
        let view = ScanPermissionProblemView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePlaceholderLabel() -> PaddingLabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100.withAlphaComponent(0.8))
            .font(Fonts.Outfit.medium(size: 14.scale))
            .textAlignment(.center)
            .lineHeight(20.scale)
        
        let view = PaddingLabel()
        view.attributedText = "Scan.Placeholder".localized.attributed(with: attrs)
        view.insets = UIEdgeInsets(vertical: 12.scale, horizontal: 20.scale)
        view.backgroundColor = Appearance.mono200.withAlphaComponent(0.5)
        view.layer.cornerRadius = 12.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
