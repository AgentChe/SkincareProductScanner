//
//  MenuTableView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 14.03.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class MenuTableView: UITableView {
    private lazy var elements = [MenuTableElement]()
    
    private lazy var didSelectTrigger = PublishRelay<MenuTableElement>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MenuTableView {
    func setup(elements: [MenuTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<MenuTableElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension MenuTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: MenuTableCell.self), for: indexPath) as! MenuTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension MenuTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension MenuTableView {
    func initialize() {
        register(MenuTableCell.self, forCellReuseIdentifier: String(describing: MenuTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
