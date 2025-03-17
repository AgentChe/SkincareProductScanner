//
//  CatalogsTableView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 17.03.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CatalogsTableView: UITableView {
    lazy var elements = [CatalogsTableElement]()
    
    private lazy var didSelectTrigger = PublishRelay<CatalogsTableElement>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CatalogsTableView {
    func setup(elements: [CatalogsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<CatalogsTableElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension CatalogsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: CatalogsTableCell.self)) as! CatalogsTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension CatalogsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = elements[indexPath.row]
        didSelectTrigger.accept(element)
    }
}

// MARK: Private
private extension CatalogsTableView {
    func initialize() {
        register(CatalogsTableCell.self, forCellReuseIdentifier: String(describing: CatalogsTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
