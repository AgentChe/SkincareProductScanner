//
//  ProductsFiltersView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 01.04.2025.
//

import UIKit

final class ProductsFiltersView: UIView {
    lazy var tableView = makeTableView()
    lazy var applyFiltersButton = makeApplyFilters()
    lazy var clearAllFiltersButton = makeClearAllFilters()
    
    private lazy var applyFiltersButtonBottomConstrant = NSLayoutConstraint()
    
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
extension ProductsFiltersView {
    func update(hasSelectedFilters: Bool) {
        applyFiltersButtonBottomConstrant.isActive = false
        applyFiltersButtonBottomConstrant = hasSelectedFilters ?
            applyFiltersButton.bottomAnchor.constraint(equalTo: clearAllFiltersButton.topAnchor, constant: -14.scale)
            : applyFiltersButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -14.scale)
        applyFiltersButtonBottomConstrant.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.layoutIfNeeded()
        })
        
        clearAllFiltersButton.isHidden = !hasSelectedFilters
    }
}

// MARK: Private
private extension ProductsFiltersView {
    func initialize() {
        backgroundColor = Appearance.main500
    }
}

// MARK: Make constraints
private extension ProductsFiltersView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: applyFiltersButton.topAnchor, constant: -2.scale)
        ])
        
        applyFiltersButtonBottomConstrant = applyFiltersButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -14.scale)
        NSLayoutConstraint.activate([
            applyFiltersButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            applyFiltersButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            applyFiltersButton.heightAnchor.constraint(equalToConstant: 54.scale),
            applyFiltersButtonBottomConstrant
        ])
        
        NSLayoutConstraint.activate([
            clearAllFiltersButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            clearAllFiltersButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            clearAllFiltersButton.heightAnchor.constraint(equalToConstant: 54.scale),
            clearAllFiltersButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -14.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ProductsFiltersView {
    func makeTableView() -> PFTableView {
        let view = PFTableView()
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .singleLine
        view.separatorColor = Appearance.main700
        view.separatorInset = UIEdgeInsets(horizontal: 16.scale)
        view.contentInset = UIEdgeInsets(vertical: 16.scale)
        view.setContentOffset(CGPoint(x: 0, y: -16.scale), animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeApplyFilters() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Outfit.medium(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle("ProductsFilters.ApplyFilters".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main100
        view.layer.cornerRadius = 12.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeClearAllFilters() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.main300)
            .font(Fonts.Outfit.medium(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle("ProductsFilters.ClearAllFilters".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main400
        view.layer.cornerRadius = 12.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
