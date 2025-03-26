//
//  ETCategoriesCollectionView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 26.03.2025.
//

import UIKit

final class ETCategoriesCollectionView: UICollectionView {
    var didSelect: ((ProductCategory) -> Void)?
    
    private lazy var elements = [ProductCategory]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ETCategoriesCollectionView {
    func setup(elements: [ProductCategory]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSources
extension ETCategoriesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: ETCategoriesCollectionCell.self), for: indexPath) as! ETCategoriesCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ETCategoriesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 120.scale, height: 122.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect?(elements[indexPath.row])
    }
}

// MARK: Private
private extension ETCategoriesCollectionView {
    func initialize() {
        register(ETCategoriesCollectionCell.self, forCellWithReuseIdentifier: String(describing: ETCategoriesCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
