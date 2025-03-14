//
//  PaygateActionsView.swift
//  LocationTracker
//
//  Created by Андрей Чернышев on 30.05.2024.
//

import UIKit

final class PaygateActionsView: UIView {
    lazy var termsOfUseButton = makeActionButton(text: "Paygate.TermsOfUse".localized)
    lazy var privacyPolicyButton = makeActionButton(text: "Paygate.PrivacyPolicy".localized)
    lazy var restoreButton = makeActionButton(text: "Paygate.RestorePurchases".localized)
    
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
private extension PaygateActionsView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension PaygateActionsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            termsOfUseButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            termsOfUseButton.topAnchor.constraint(equalTo: topAnchor),
            termsOfUseButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            termsOfUseButton.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 20.scale : 14.scale)
        ])
        
        NSLayoutConstraint.activate([
            privacyPolicyButton.leadingAnchor.constraint(equalTo: termsOfUseButton.trailingAnchor, constant: 12.scale),
            privacyPolicyButton.topAnchor.constraint(equalTo: topAnchor),
            privacyPolicyButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            privacyPolicyButton.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 20.scale : 14.scale)
        ])
        
        NSLayoutConstraint.activate([
            restoreButton.leadingAnchor.constraint(equalTo: privacyPolicyButton.trailingAnchor, constant: 12.scale),
            restoreButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            restoreButton.topAnchor.constraint(equalTo: topAnchor),
            restoreButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            restoreButton.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 20.scale : 14.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateActionsView {
    func makeActionButton(text: String) -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.6))
            .font(Fonts.Outfit.regular(size: 14.scale))
        
        let view = TapAreaButton()
        view.backgroundColor = UIColor.clear
        view.setAttributedTitle(text.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
