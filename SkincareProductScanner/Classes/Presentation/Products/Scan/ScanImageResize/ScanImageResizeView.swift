//
//  ScanImageResizeView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 31.10.2024.
//

import UIKit

final class ScanImageResizeView: UIView {
    lazy var imageContainer = makeImageContainer()
    lazy var optionsView = makeOptionsView()
    
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
private extension ScanImageResizeView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension ScanImageResizeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32.scale),
            imageContainer.widthAnchor.constraint(equalToConstant: 330.scale),
            imageContainer.heightAnchor.constraint(equalToConstant: 467.scale)
        ])
        
        NSLayoutConstraint.activate([
            optionsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            optionsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            optionsView.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 32.scale),
            optionsView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ScanImageResizeView {
    func makeImageContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeOptionsView() -> ScanImageResizeOptionsView {
        let view = ScanImageResizeOptionsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
