//
//  ExploreView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 14.03.2025.
//

import UIKit

final class ExploreView: UIView {
    lazy var backgroundView = makeBackgroundView()
    lazy var headerView = makeHeaderView()
    
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
private extension ExploreView {
    func initialize() {
        backgroundColor = Appearance.main500
    }
}

// MARK: Make constraints
private extension ExploreView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 449.scale)
        ])
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 34.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ExploreView {
    func makeBackgroundView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Explore.Background")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeHeaderView() -> ExploreHeaderView {
        let view = ExploreHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
