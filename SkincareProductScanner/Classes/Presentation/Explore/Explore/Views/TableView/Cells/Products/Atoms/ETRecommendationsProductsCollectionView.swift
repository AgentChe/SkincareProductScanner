//
//  ETRecommendationsProductsCollectionView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 25.03.2025.
//

import UIKit

final class ETRecommendationsProductsCollectionView: UICollectionView {
    var didSelect: ((Product) -> Void)?
    
    private lazy var elements = [Product]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ETRecommendationsProductsCollectionView {
    func setup(elements: [Product]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSources
extension ETRecommendationsProductsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: ETRecommendationsProductsCollectionCell.self), for: indexPath) as! ETRecommendationsProductsCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ETRecommendationsProductsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 144.scale, height: 217.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect?(elements[indexPath.row])
    }
}

// MARK: Private
private extension ETRecommendationsProductsCollectionView {
    func initialize() {
        register(ETRecommendationsProductsCollectionCell.self, forCellWithReuseIdentifier: String(describing: ETRecommendationsProductsCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
