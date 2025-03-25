//
//  ETSTGPCollectionView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 25.03.2025.
//

import UIKit

final class ETSTGPCollectionView: UICollectionView {
    var didSelect: ((ExploreSTGPElement) -> Void)?
    
    private lazy var elements = [ExploreSTGPElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ETSTGPCollectionView {
    func setup(elements: [ExploreSTGPElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSources
extension ETSTGPCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: ETSTGPCollectionCell.self), for: indexPath) as! ETSTGPCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ETSTGPCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        ETSTGPCollectionCell.size(for: elements[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect?(elements[indexPath.row])
    }
}

// MARK: Private
private extension ETSTGPCollectionView {
    func initialize() {
        register(ETSTGPCollectionCell.self, forCellWithReuseIdentifier: String(describing: ETSTGPCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
