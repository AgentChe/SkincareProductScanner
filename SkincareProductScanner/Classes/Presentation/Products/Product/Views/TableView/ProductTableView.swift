//
//  ProductTableView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 03.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class ProductTableView: UITableView {
    private lazy var elements = [ProductTableElement]()
    
    private lazy var didSelectProductTrigger = PublishRelay<Product>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ProductTableView {
    func setup(elements: [ProductTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelectProduct: Signal<Product> {
        didSelectProductTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension ProductTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .titleBrand(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: PTTitleBrandCell.self), for: indexPath) as! PTTitleBrandCell
            cell.setup(element: element)
            return cell
        case .text(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: PTTextCell.self), for: indexPath) as! PTTextCell
            cell.setup(element: element)
            return cell
        case .stgp(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: PTSTGPCell.self), for: indexPath) as! PTSTGPCell
            cell.collectionView.setup(elements: element)
            return cell
        case .titleValue(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: PTTitleCell.self), for: indexPath) as! PTTitleCell
            cell.setup(element: element)
            return cell
        case .similarProducts(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: PTSimilarProductsCell.self), for: indexPath) as! PTSimilarProductsCell
            cell.collectionView.setup(elements: element)
            cell.collectionView.didSelect = { [weak self] product in
                self?.didSelectProductTrigger.accept(product)
            }
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension ProductTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Private
private extension ProductTableView {
    func initialize() {
        register(PTTitleBrandCell.self, forCellReuseIdentifier: String(describing: PTTitleBrandCell.self))
        register(PTTextCell.self, forCellReuseIdentifier: String(describing: PTTextCell.self))
        register(PTSTGPCell.self, forCellReuseIdentifier: String(describing: PTSTGPCell.self))
        register(PTTitleCell.self, forCellReuseIdentifier: String(describing: PTTitleCell.self))
        register(PTSimilarProductsCell.self, forCellReuseIdentifier: String(describing: PTSimilarProductsCell.self))
        
        dataSource = self
        delegate = self
    }
}
