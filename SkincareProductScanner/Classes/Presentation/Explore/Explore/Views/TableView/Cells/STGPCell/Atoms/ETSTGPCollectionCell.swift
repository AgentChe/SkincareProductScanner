//
//  ETSTGPCollectionCell.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 25.03.2025.
//

import UIKit

final class ETSTGPCollectionCell: UICollectionViewCell {
    lazy var label = makeLabel()
    
    private static let skinTypeAttrs = TextAttributes()
        .textColor(Appearance.custom57_142_233)
        .font(Fonts.Outfit.medium(size: 14.scale))
        .lineHeight(20.scale)
        .textAlignment(.center)
    private static let goalAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Outfit.medium(size: 14.scale))
        .lineHeight(20.scale)
        .textAlignment(.center)
    private static let preferenceAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Outfit.medium(size: 14.scale))
        .lineHeight(20.scale)
        .textAlignment(.center)
    
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
extension ETSTGPCollectionCell {
    static func size(for element: ExploreSTGPElement) -> CGSize {
        let size = element.name.attributed(with: Self.skinTypeAttrs).size()
        return CGSize(width: size.width + 16.scale, height: size.height + 6.scale)
    }
    
    func setup(element: ExploreSTGPElement) {
        let attrs: TextAttributes = {
            switch element {
            case .skinType:
                return Self.skinTypeAttrs
            case .goal:
                return Self.goalAttrs
            case .preference:
                return Self.preferenceAttrs
            }
        }()
        label.attributedText = element.name.attributed(with: attrs)
        
        label.backgroundColor = {
            switch element {
            case .skinType:
                return Appearance.main200
            case .goal:
                return Appearance.custom223_144_178
            case .preference:
                return Appearance.main900
            }
        }()
    }
}

// MARK: Private
private extension ETSTGPCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension ETSTGPCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ETSTGPCollectionCell {
    func makeLabel() -> PaddingLabel {
        let view = PaddingLabel()
        view.insets = UIEdgeInsets(t: 2.scale, l: 8.scale, b: 4.scale, r: 8.scale)
        view.layer.cornerRadius = 13.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

// MARK: Additional
private extension ExploreSTGPElement {
    var name: String {
        switch self {
        case .skinType(let skinType):
            return skinType.name
        case .goal(let goal):
            return goal.name
        case .preference(let preference):
            return preference.name
        }
    }
}
