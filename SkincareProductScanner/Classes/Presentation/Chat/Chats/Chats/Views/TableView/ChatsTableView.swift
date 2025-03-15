//
//  ChatsTableView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 28.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class ChatsTableView: UITableView {
    private lazy var sections = [ChatsTableSection]()
    
    private lazy var didSelectTrigger = PublishRelay<Chat>()
    private lazy var didDeleteTrigger = PublishRelay<Chat>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ChatsTableView {
    func setup(sections: [ChatsTableSection]) {
        self.sections = sections
        
        reloadData()
    }
    
    var didSelect: Signal<Chat> {
        didSelectTrigger.asSignal()
    }
    
    var didDelete: Signal<Chat> {
        didDeleteTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension ChatsTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].chats.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = dequeueReusableHeaderFooterView(withIdentifier: String(describing: ChatsTableHeaderView.self)) as! ChatsTableHeaderView
        view.setup(element: sections[section].title)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard (sections.count - 1) != section else { return nil }
        
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: ChatsTableFooterView.self))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: ChatsTableCell.self), for: indexPath) as! ChatsTableCell
        cell.setup(chat: sections[indexPath.section].chats[indexPath.row])
        cell.didTapDelete = { [weak self] in
            guard let self else { return  }
            
            let chat = sections[indexPath.section].chats[indexPath.row]
            didDeleteTrigger.accept(chat)
        }
        return cell
    }
}

// MARK: UITableViewDelegate
extension ChatsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = sections[indexPath.section].chats[indexPath.row]
        didSelectTrigger.accept(chat)
    }
}

// MARK: Private
private extension ChatsTableView {
    func initialize() {
        register(ChatsTableHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: ChatsTableHeaderView.self))
        register(ChatsTableFooterView.self, forHeaderFooterViewReuseIdentifier: String(describing: ChatsTableFooterView.self))
        register(ChatsTableCell.self, forCellReuseIdentifier: String(describing: ChatsTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
