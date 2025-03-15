//
//  ChatAnswerCell.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 29.10.2024.
//

import UIKit

final class ChatAnswerCell: UITableViewCell {
    var didTapRefresh: (() -> Void)?
    var didTapCopy: (() -> Void)?
    
    lazy var robotView = makeRobotView()
    lazy var container = makeContainer()
    lazy var label = makeLabel()
    lazy var copyButton = makeActionButton(iconName: "Chat.Copy")
    lazy var refreshButton = makeActionButton(iconName: "Chat.Refresh")
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Outfit.regular(size: 16.scale))
        .lineHeight(22.scale)
        .textAlignment(.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ChatAnswerCell {
    func setup(text: String, refreshHidden: Bool) {
        let html: NSAttributedString = {
            let font = Fonts.Outfit.regular(size: 16.scale)
            let htmlWithStyle = "<span style=\"font-family: \(font.fontName); font-style: regular; font-size: \(font.pointSize); line-height: \(22.scale)px;\">\(text)</span>"
            
            guard let data = htmlWithStyle.data(using: .utf8) else { return text.attributed(with: attrs) }
            
            let attributedString = try? NSMutableAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            guard let attributedString else { return text.attributed(with: attrs) }
            
            if attributedString.string.last == "\n" {
                attributedString.mutableString.deleteCharacters(in: NSRange(location: attributedString.length - 1, length: 1))
            }
            
            return attributedString
        }()
        label.attributedText = html
        
        refreshButton.isHidden = refreshHidden
    }
}

// MARK: Private
private extension ChatAnswerCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
        
        refreshButton.addTarget(self, action: #selector(refreshTapped), for: .touchUpInside)
        copyButton.addTarget(self, action: #selector(copyTapped), for: .touchUpInside)
    }
    
    @objc
    func refreshTapped() {
        didTapRefresh?()
    }
    
    @objc
    func copyTapped() {
        didTapCopy?()
    }
}

// MARK: Make constraints
private extension ChatAnswerCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            robotView.widthAnchor.constraint(equalToConstant: 24.scale),
            robotView.heightAnchor.constraint(equalToConstant: 24.scale),
            robotView.topAnchor.constraint(equalTo: container.topAnchor),
            robotView.trailingAnchor.constraint(equalTo: container.leadingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 56.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -56.scale)
        ])
        
        NSLayoutConstraint.activate([
            copyButton.widthAnchor.constraint(equalToConstant: 24.scale),
            copyButton.heightAnchor.constraint(equalToConstant: 24.scale),
            copyButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            copyButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            refreshButton.widthAnchor.constraint(equalToConstant: 24.scale),
            refreshButton.heightAnchor.constraint(equalToConstant: 24.scale),
            refreshButton.leadingAnchor.constraint(equalTo: copyButton.trailingAnchor, constant: 16.scale),
            refreshButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ChatAnswerCell {
    func makeRobotView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Chat.Robot")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 25.scale
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeActionButton(iconName: String) -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: iconName), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
