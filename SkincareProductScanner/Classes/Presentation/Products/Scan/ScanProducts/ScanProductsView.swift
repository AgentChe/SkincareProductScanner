//
//  ScanProductsView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 31.03.2025.
//

import UIKit

final class ScanProductsView: UIView {
    lazy var subTitleLabel = makeLabel()
    lazy var tableView = makeTableView()
    lazy var emptyView = makeEmptyView()
    lazy var newSearchButton = makeNewSearchButton()
    
    private lazy var subTitleAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Outfit.medium(size: 18.scale))
        .lineHeight(23.scale)
        .textAlignment(.left)
    
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
extension ScanProductsView {
    func setup(empty: Bool) {
        let subTitle = empty ? "ScanProducts.SubTitle.Empty".localized : "ScanProducts.SubTitle.Result".localized
        subTitleLabel.attributedText = subTitle.attributed(with: subTitleAttrs)
        
        emptyView.isHidden = !empty
    }
}

// MARK: Private
private extension ScanProductsView {
    func initialize() {
        backgroundColor = Appearance.main500
    }
}

// MARK: Make constraints
private extension ScanProductsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: newSearchButton.topAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 63.scale),
            emptyView.bottomAnchor.constraint(equalTo: newSearchButton.topAnchor, constant: -120.scale)
        ])
        
        NSLayoutConstraint.activate([
            newSearchButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            newSearchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            newSearchButton.heightAnchor.constraint(equalToConstant: 54.scale),
            newSearchButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -14.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ScanProductsView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> RecommendationsTableView {
        let view = RecommendationsTableView()
        view.backgroundColor = UIColor.clear
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(vertical: 8.scale)
        view.setContentOffset(CGPoint(x: 0, y: -8.scale), animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmptyView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.image = UIImage(named: "ScanProducts.Empty")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNewSearchButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.medium(size: 18.scale))
        
        let view = UIButton()
        view.backgroundColor = Appearance.main700
        view.layer.cornerRadius = 16.scale
        view.setAttributedTitle("ScanProducts.NewSearch".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
