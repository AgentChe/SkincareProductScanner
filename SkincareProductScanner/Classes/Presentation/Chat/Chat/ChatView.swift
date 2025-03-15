//
//  ChatView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 26.10.2024.
//

import UIKit

final class ChatView: UIView {
    lazy var backgroundView = makeBackgroundView()
    lazy var titleLabel = makeTitleLabel()
    lazy var startNewChatButton = makeStartNewChatButton()
    lazy var historyButton = makeHistoryButton()
    lazy var placeholderView = makePlaceholderView()
    lazy var tableView = makeTableView()
    lazy var inputField = makeInputField()
    lazy var regenerateView = makeRegenerateView()
    
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
private extension ChatView {
    func initialize() {
        backgroundColor = Appearance.main500
    }
}

// MARK: Make constraints
private extension ChatView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 90.scale),
            backgroundView.heightAnchor.constraint(equalToConstant: 449.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            startNewChatButton.widthAnchor.constraint(equalToConstant: 24.scale),
            startNewChatButton.heightAnchor.constraint(equalToConstant: 24.scale),
            startNewChatButton.trailingAnchor.constraint(equalTo: historyButton.leadingAnchor, constant: -16.scale),
            startNewChatButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            historyButton.widthAnchor.constraint(equalToConstant: 24.scale),
            historyButton.heightAnchor.constraint(equalToConstant: 24.scale),
            historyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            historyButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            placeholderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            placeholderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            placeholderView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: inputField.topAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            inputField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            inputField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            inputField.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -14.scale)
        ])
        
        NSLayoutConstraint.activate([
            regenerateView.leadingAnchor.constraint(equalTo: leadingAnchor),
            regenerateView.trailingAnchor.constraint(equalTo: trailingAnchor),
            regenerateView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -14.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ChatView {
    func makeBackgroundView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Chat.Background")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.bold(size: 22.scale))
            .lineHeight(34.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Chat.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeStartNewChatButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Chat.StartNewChat"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeHistoryButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Chat.History"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePlaceholderView() -> ChatPlaceholderView {
        let view = ChatPlaceholderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> ChatTableView {
        let view = ChatTableView()
        view.contentInset = UIEdgeInsets(t: 16.scale, b: 42.scale)
        view.setContentOffset(CGPoint(x: 0, y: -16.scale), animated: false)
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeInputField() -> ChatInputField {
        let view = ChatInputField()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRegenerateView() -> ChatRegenerateView {
        let view = ChatRegenerateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
