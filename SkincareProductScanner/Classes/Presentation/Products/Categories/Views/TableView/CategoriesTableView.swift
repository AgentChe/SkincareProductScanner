//
//  CategoriesTableView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 26.03.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CategoriesTableView: UITableView {
    private lazy var elements = [ProductCategory]()
    
    private lazy var didSelectTrigger = PublishRelay<ProductCategory>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CategoriesTableView {
    func setup(elements: [ProductCategory]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<ProductCategory> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension CategoriesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: CategoriesTableCell.self), for: indexPath) as! CategoriesTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension CategoriesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension CategoriesTableView {
    func initialize() {
        register(CategoriesTableCell.self, forCellReuseIdentifier: String(describing: CategoriesTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
