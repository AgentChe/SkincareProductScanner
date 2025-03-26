//
//  ExploreTableCategoriesTitleCell.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 26.03.2025.
//

import UIKit

final class ExploreTableCategoriesTitleCell: UITableViewCell {
    var didTapSeeAll: (() -> Void)?
    
    lazy var iconView = makeIconView()
    lazy var exploreMoreLabel = makeExploreMoreLabel()
    lazy var titleLabel = makeTitleLabel()
    lazy var seeAllButton = makeSeeAllButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ExploreTableCategoriesTitleCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func seeAllTapped() {
        didTapSeeAll?()
    }
}

// MARK: Make constraints
private extension ExploreTableCategoriesTitleCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 12.scale),
            iconView.heightAnchor.constraint(equalToConstant: 12.scale),
            iconView.trailingAnchor.constraint(equalTo: exploreMoreLabel.leadingAnchor, constant: -5.scale),
            iconView.centerYAnchor.constraint(equalTo: exploreMoreLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            exploreMoreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 33.scale),
            exploreMoreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            exploreMoreLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: exploreMoreLabel.bottomAnchor, constant: 2.scale),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            seeAllButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            seeAllButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ExploreTableCategoriesTitleCell {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Explore.Categories.Title.Icon")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeExploreMoreLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.6))
            .font(Fonts.Outfit.regular(size: 14.scale))
            .lineHeight(20.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Explore.Categories.Title.ExploreMore".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.bold(size: 18.scale))
            .lineHeight(23.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Explore.Categories.Title.PopularProducts".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSeeAllButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.5))
            .font(Fonts.Outfit.medium(size: 16.scale))
        
        let view = TapAreaButton()
        view.setAttributedTitle("Explore.SeeAll".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(seeAllTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}
