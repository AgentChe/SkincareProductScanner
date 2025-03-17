//
//  ExploreTableBookmarksCell.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 17.03.2025.
//

import UIKit

final class ExploreTableBookmarksCell: UITableViewCell {
    lazy var backgroundImageView = makeBackgroundImageView()
    lazy var iconView = makeIconView()
    lazy var textContainer = makeTextContainer()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var arrowView = makeArrowView()
    
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
private extension ExploreTableBookmarksCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ExploreTableBookmarksCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.scale),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 80.scale)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 48.scale),
            iconView.heightAnchor.constraint(equalToConstant: 48.scale),
            iconView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 16.scale),
            iconView.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textContainer.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 72.scale),
            textContainer.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -72.scale),
            textContainer.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: textContainer.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: textContainer.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: textContainer.trailingAnchor),
            subTitleLabel.bottomAnchor.constraint(equalTo: textContainer.bottomAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.scale)
        ])
        
        NSLayoutConstraint.activate([
            arrowView.widthAnchor.constraint(equalToConstant: 48.scale),
            arrowView.heightAnchor.constraint(equalToConstant: 48.scale),
            arrowView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -16.scale),
            arrowView.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ExploreTableBookmarksCell {
    func makeBackgroundImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Explore.Bookmarks.Background")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Explore.Bookmarks.Icon")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTextContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.semiBold(size: 18.scale))
            .lineHeight(23.scale)
        
        let view = UILabel()
        view.attributedText = "Explore.Bookmarks.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        textContainer.addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.medium(size: 14.scale))
            .lineHeight(20.scale)
        
        let view = UILabel()
        view.attributedText = "Explore.Bookmarks.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        textContainer.addSubview(view)
        return view
    }
    
    func makeArrowView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Explore.Bookmarks.Arrow")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
