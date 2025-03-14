//
//  TabView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import UIKit

final class TabView: UIView {
    enum Tab {
        case explore, scan, chat
    }
    
    lazy var container = makeContainer()
    lazy var exploreButton = makeButton(imageDomain: "Main.Explore")
    lazy var scanButton = makeScanButton()
    lazy var chatButton = makeButton(imageDomain: "Main.Chat")
    
    var selectedTab = Tab.explore {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TabView {
    func update() {
        exploreButton.marked = selectedTab == .explore
        chatButton.marked = selectedTab == .chat
    }
}

// MARK: Make constraints
private extension TabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor, constant: 12.scale),
            container.heightAnchor.constraint(equalToConstant: 90.scale)
        ])
        
        NSLayoutConstraint.activate([
            exploreButton.widthAnchor.constraint(equalToConstant: 24.scale),
            exploreButton.heightAnchor.constraint(equalToConstant: 24.scale),
            exploreButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 23.scale),
            exploreButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 66.scale)
        ])
        
        NSLayoutConstraint.activate([
            scanButton.widthAnchor.constraint(equalToConstant: 68.scale),
            scanButton.heightAnchor.constraint(equalToConstant: 68.scale),
            scanButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            scanButton.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            chatButton.widthAnchor.constraint(equalToConstant: 24.scale),
            chatButton.heightAnchor.constraint(equalToConstant: 24.scale),
            chatButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 23.scale),
            chatButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -66.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TabView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.backgroundColor = Appearance.mono100
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeScanButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Main.Scan"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton(imageDomain: String) -> TabItemButton {
        let view = TabItemButton(imageDomain: imageDomain)
        view.dx = -15.scale
        view.dy = -15.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
