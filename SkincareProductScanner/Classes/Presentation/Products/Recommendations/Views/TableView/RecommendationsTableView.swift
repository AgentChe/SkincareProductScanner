//
//  RecommendationsTableView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 25.03.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class RecommendationsTableView: UITableView {
    private lazy var elements = [Product]()
    
    private lazy var didSelectTrigger = PublishRelay<Product>()
    private lazy var didScrollToBottomTrigger = PublishRelay<Void>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension RecommendationsTableView {
    func setup(elements: [Product]) {
        self.elements = elements
        
        reloadData()
    }
    
    func append(elements: [Product]) {
        self.elements.append(contentsOf: elements)
        
        reloadData()
    }
    
    func remove(id: String) {
        elements.removeAll(where: { $0.id == id })
        
        reloadData()
    }
    
    var didSelect: Signal<Product> {
        didSelectTrigger.asSignal()
    }
    
    var didScrollToBottom: Signal<Void> {
        didScrollToBottomTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension RecommendationsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: RecommendationsTableCell.self), for: indexPath) as! RecommendationsTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension RecommendationsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard (elements.count - 1) == indexPath.row else { return }
        didScrollToBottomTrigger.accept(Void())
    }
}

// MARK: Private
private extension RecommendationsTableView {
    func initialize() {
        register(RecommendationsTableCell.self, forCellReuseIdentifier: String(describing: RecommendationsTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
