//
//  AllProductsSearchField.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 01.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class AllProductsSearchField: UIView {
    lazy var iconView = makeIconView()
    lazy var textField = makeTextField()
    
    private lazy var didTapSearchTrigger = PublishRelay<String>()
    private lazy var text = BehaviorRelay(value: "")
    
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
extension AllProductsSearchField {
    var didTapSearch: Signal<String> {
        didTapSearchTrigger.asSignal()
    }
    
    var changedText: Signal<String> {
        text.asSignal(onErrorSignalWith: .never())
    }
}

// MARK: UITextFieldDelegate
extension AllProductsSearchField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        didTapSearchTrigger.accept(textField.text ?? "")
        
        return true
    }
}

// MARK: Private
private extension AllProductsSearchField {
    func initialize() {
        backgroundColor = Appearance.mono100
        layer.cornerRadius = 12.scale
        layer.masksToBounds = true
        layer.borderWidth = 1.scale
        layer.borderColor = Appearance.main700.cgColor
    }
    
    @objc
    func textEditing() {
        text.accept(textField.text ?? "")
    }
}

// MARK: Make constraints
private extension AllProductsSearchField {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48.scale),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension AllProductsSearchField {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "AllProducts.Search")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextField() -> PaddingTextField {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.regular(size: 16.scale))
            .lineHeight(22.scale)
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.5))
            .font(Fonts.Outfit.regular(size: 16.scale))
            .lineHeight(22.scale)
        
        let view = PaddingTextField()
        view.backgroundColor = UIColor.clear
        view.delegate = self
        view.returnKeyType = .search
        view.defaultTextAttributes = attrs.dictionary
        view.attributedPlaceholder = "AllProducts.Search.Placeholder".localized.attributed(with: placeholderAttrs)
        view.textPadding = UIEdgeInsets(vertical: 13.scale)
        view.addTarget(self, action: #selector(textEditing), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
