//
//  ReferencesView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 14.03.2025.
//

import UIKit

final class ReferencesView: UIView {
    lazy var block1Label = makeBlock1Label()
    lazy var block2Label = makeBlock2Label()
    lazy var link1Button = makeLinkButton(url: GlobalDefinitions.References.link1)
    lazy var link2Button = makeLinkButton(url: GlobalDefinitions.References.link2)
    
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
private extension ReferencesView {
    func initialize() {
        backgroundColor = Appearance.main500
    }
}

// MARK: Make constraints
private extension ReferencesView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            block1Label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            block1Label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            block1Label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            block2Label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            block2Label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            block2Label.topAnchor.constraint(equalTo: block1Label.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            link1Button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            link1Button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            link1Button.topAnchor.constraint(equalTo: block2Label.bottomAnchor, constant: 16.scale),
            link1Button.heightAnchor.constraint(equalToConstant: 18.scale)
        ])
        
        NSLayoutConstraint.activate([
            link2Button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            link2Button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            link2Button.topAnchor.constraint(equalTo: link1Button.bottomAnchor, constant: 4.scale),
            link2Button.heightAnchor.constraint(equalToConstant: 18.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ReferencesView {
    func makeBlock1Label() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.bold(size: 16.scale))
            .lineHeight(19.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "References.Block1".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBlock2Label() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.regular(size: 16.scale))
            .lineHeight(19.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "References.Block2".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLinkButton(url: URL) -> ReferencesLinkButton {
        let view = ReferencesLinkButton(url: url)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
