//
//  AllProductsTableView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 01.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class AllProductsTableView: UITableView {
    lazy var sections = [APTableSection]()
    
    private lazy var didSelectPresetTrigger = PublishRelay<String>()
    private lazy var didSelectProductTrigger = PublishRelay<Product>()
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
extension AllProductsTableView {
    func setup(sections: [APTableSection]) {
        self.sections = sections
        
        reloadData()
    }
    
    var didSelectPreset: Signal<String> {
        didSelectPresetTrigger.asSignal()
    }
    
    var didSelectProduct: Signal<Product> {
        didSelectProductTrigger.asSignal()
    }
    
    var didScrollToBottom: Signal<Void> {
        didScrollToBottomTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension AllProductsTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let s = sections[section]
        return s.opened ? s.openedElements.count : s.closedElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let elements = section.opened ? section.openedElements : section.closedElements
        
        switch elements[indexPath.row] {
        case .presetSection(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: APPresetSectionCell.self)) as! APPresetSectionCell
            cell.setup(element: element)
            return cell
        case .presetItem(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: APPresetItemCell.self)) as! APPresetItemCell
            cell.setup(element: element)
            return cell
        case .product(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: RecommendationsTableCell.self)) as! RecommendationsTableCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension AllProductsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = sections[safe: indexPath.section] else { return }
        
        let elements = section.opened ? section.openedElements : section.closedElements
        
        guard let element = elements[safe: indexPath.row] else { return }
        
        switch element {
        case .presetSection(let element):
            section.opened.toggle()
            element.opened.toggle()
            
            reloadSections([indexPath.section], with: .automatic)
        case .presetItem(let element):
            didSelectPresetTrigger.accept(element)
        case .product(let product):
            didSelectProductTrigger.accept(product)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let elements = section.opened ? section.openedElements : section.closedElements
        
        guard (elements.count - 1) == indexPath.row else { return }
        
        didScrollToBottomTrigger.accept(Void())
    }
}

// MARK: Private
private extension AllProductsTableView {
    func initialize() {
        register(APPresetSectionCell.self, forCellReuseIdentifier: String(describing: APPresetSectionCell.self))
        register(APPresetItemCell.self, forCellReuseIdentifier: String(describing: APPresetItemCell.self))
        register(RecommendationsTableCell.self, forCellReuseIdentifier: String(describing: RecommendationsTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
