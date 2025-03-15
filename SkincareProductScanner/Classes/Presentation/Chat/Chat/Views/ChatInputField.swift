//
//  ChatInputField.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class ChatInputField: UIView {
    lazy var textField = makeTextField()
    lazy var sendButton = makeSendButton()
    
    private lazy var focusChangedTrigger = PublishRelay<Bool>()
    
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
extension ChatInputField {
    var focusChanged: Signal<Bool> {
        focusChangedTrigger.asSignal()
    }
}

// MARK: UITextFieldDelegate
extension ChatInputField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        focusChangedTrigger.accept(true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        focusChangedTrigger.accept(false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Private
private extension ChatInputField {
    func initialize() {
        backgroundColor = Appearance.mono100
        layer.cornerRadius = 12.scale
        layer.borderWidth = 1.scale
        layer.borderColor = Appearance.main700.cgColor
    }
}

// MARK: Make constraints
private extension ChatInputField {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            sendButton.widthAnchor.constraint(equalToConstant: 24.scale),
            sendButton.heightAnchor.constraint(equalToConstant: 24.scale),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22.scale),
            sendButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ChatInputField {
    func makeTextField() -> PaddingTextField {
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.5))
            .font(Fonts.Outfit.regular(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.left)
        let textAttrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.regular(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.left)
        
        let view = PaddingTextField()
        view.textPadding = UIEdgeInsets(t: 16.scale, l: 22.scale, b: 16.scale, r: 50.scale)
        view.defaultTextAttributes = textAttrs.dictionary
        view.attributedPlaceholder = "Chat.Input.Placeholder".localized.attributed(with: placeholderAttrs)
        view.delegate = self
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSendButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Chat.Input"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
