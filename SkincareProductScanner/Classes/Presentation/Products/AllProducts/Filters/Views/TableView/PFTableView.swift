//
//  PFTableView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 01.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class PFTableView: UITableView {
    lazy var sections = [PFTableSection]()
    
    private lazy var didTapItemTrigger = PublishRelay<PFItemElement>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension PFTableView {
    func setup(sections: [PFTableSection]) {
        self.sections = sections
        
        reloadData()
    }
    
    func resetMarkedFilters() {
        sections.forEach { section in
            let allElements = section.openedElements + section.closedElements
            allElements.forEach { element in
                switch element {
                case .item(let item):
                    item.marked = false
                default:
                    break
                }
            }
        }
        
        reloadData()
    }
    
    var didTapItem: Signal<PFItemElement> {
        didTapItemTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension PFTableView: UITableViewDataSource {
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
        case .section(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: PFTableSectionCell.self)) as! PFTableSectionCell
            cell.setup(name: element.name, opened: element.opened)
            return cell
        case .item(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: PFTableItemCell.self)) as! PFTableItemCell
            cell.setup(name: element.item.name, marked: element.marked)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension PFTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = sections[safe: indexPath.section] else { return }
        
        let elements = section.opened ? section.openedElements : section.closedElements
        
        guard let element = elements[safe: indexPath.row] else { return }
        
        switch element {
        case .section(let element):
            section.opened.toggle()
            element.opened.toggle()
            
            reloadSections([indexPath.section], with: .automatic)
        case .item(let element):
            element.marked.toggle()
            
            reloadRows(at: [indexPath], with: .automatic)
            
            didTapItemTrigger.accept(element)
        }
    }
}

// MARK: Private
private extension PFTableView {
    func initialize() {
        register(PFTableSectionCell.self, forCellReuseIdentifier: String(describing: PFTableSectionCell.self))
        register(PFTableItemCell.self, forCellReuseIdentifier: String(describing: PFTableItemCell.self))
        
        dataSource = self
        delegate = self
    }
}
