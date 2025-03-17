//
//  CDTableView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 23.10.2024.
//

import UIKit

final class CDTableView: UITableView {
    lazy var sections = [CDTableSection]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CDTableView {
    func setup(sections: [CDTableSection]) {
        self.sections = sections
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension CDTableView: UITableViewDataSource {
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
        case .name(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CDTableNameCell.self)) as! CDTableNameCell
            cell.setup(element: element)
            return cell
        case .section(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CDTableSectionCell.self)) as! CDTableSectionCell
            cell.setup(name: element.name, opened: element.opened)
            return cell
        case .title(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CDTableTitleCell.self)) as! CDTableTitleCell
            cell.setup(element: element)
            return cell
        case .text(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CDTableTextCell.self)) as! CDTableTextCell
            cell.setup(element: element)
            return cell
        case .image(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CDTableImageCell.self)) as! CDTableImageCell
            cell.setup(element: element)
            return cell
        case .separator:
            return dequeueReusableCell(withIdentifier: String(describing: CDTableSeparatorCell.self), for: indexPath)
        }
    }
}

// MARK: UITableViewDelegate
extension CDTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let elements = section.opened ? section.openedElements : section.closedElements
        
        guard case let .section(element) = elements[indexPath.row] else {
            return
        }
        
        element.opened.toggle()
        section.opened.toggle()
        
        reloadSections([indexPath.section], with: .automatic)
    }
}

// MARK: Private
private extension CDTableView {
    func initialize() {
        register(CDTableTitleCell.self, forCellReuseIdentifier: String(describing: CDTableTitleCell.self))
        register(CDTableSeparatorCell.self, forCellReuseIdentifier: String(describing: CDTableSeparatorCell.self))
        register(CDTableTextCell.self, forCellReuseIdentifier: String(describing: CDTableTextCell.self))
        register(CDTableNameCell.self, forCellReuseIdentifier: String(describing: CDTableNameCell.self))
        register(CDTableSectionCell.self, forCellReuseIdentifier: String(describing: CDTableSectionCell.self))
        register(CDTableImageCell.self, forCellReuseIdentifier: String(describing: CDTableImageCell.self))
        
        dataSource = self
        delegate = self
    }
}
