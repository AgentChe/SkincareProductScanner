//
//  BookmarksCatalogsTableView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 18.03.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class BookmarksCatalogsTableView: UITableView {
    private lazy var elements = [BookmarksCatalogsTableElement]()
    
    private lazy var didSelectTrigger = PublishRelay<BookmarksCatalogsTableElement>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension BookmarksCatalogsTableView {
    func setup(elements: [BookmarksCatalogsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<BookmarksCatalogsTableElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension BookmarksCatalogsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: BookmarksCatalogsTableCell.self), for: indexPath) as! BookmarksCatalogsTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension BookmarksCatalogsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension BookmarksCatalogsTableView {
    func initialize() {
        register(BookmarksCatalogsTableCell.self, forCellReuseIdentifier: String(describing: BookmarksCatalogsTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
