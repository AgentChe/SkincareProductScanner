//
//  ReferencesLinkButton.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 14.03.2025.
//

import UIKit
import RxCocoa

final class ReferencesLinkButton: UIButton {
    let url: URL
    
    init(url: URL) {
        self.url = url
        
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ReferencesLinkButton {
    var didTap: Signal<URL> {
        rx.tap
            .compactMap { [weak self] in self?.url }
            .asSignal(onErrorSignalWith: .never())
    }
}

// MARK: Private
private extension ReferencesLinkButton {
    func initialize() {
        let attrs = TextAttributes()
            .textColor(Appearance.main100)
            .font(Fonts.Outfit.regular(size: 16.scale))
        setAttributedTitle(url.absoluteString.attributed(with: attrs), for: .normal)
        
        backgroundColor = UIColor.clear
        contentHorizontalAlignment = .left
    }
}
