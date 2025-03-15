//
//  ChatTableView.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 29.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class ChatTableView: UITableView {
    private lazy var elements = [ChatTableElement]()
    
    private lazy var didRefreshTrigger = PublishRelay<ChatTableAnswerElement>()
    private lazy var didCopyTrigger = PublishRelay<String>()
    private lazy var didScrollToTopTrigger = PublishRelay<Void>()
    private lazy var didChangeElementsCountTrigger = PublishRelay<Int>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ChatTableView {
    func reset() {
        elements = []
        
        reloadData()
        
        didChangeElementsCountTrigger.accept(elements.count)
    }
    
    func insert(elements: [ChatTableElement]) {
        self.elements.insert(contentsOf: elements, at: 0)
        
        reloadData()
        
        if self.elements.count == elements.count {
            let index = IndexPath(row: self.elements.count - 1, section: 0)
            scrollToRow(at: index, at: .bottom, animated: false)
        } else {
            let index = self.elements.count - elements.count
            if elements.indices.contains(index) {
                let indexPath = IndexPath(row: index, section: 0)
                scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
        
        didChangeElementsCountTrigger.accept(elements.count)
    }
    
    func add(elements: [ChatTableElement]) {
        self.elements.append(contentsOf: elements)
        
        reloadData()
        
        if !self.elements.isEmpty {
            let index = IndexPath(row: self.elements.count - 1, section: 0)
            scrollToRow(at: index, at: .bottom, animated: false)
        }
        
        didChangeElementsCountTrigger.accept(elements.count)
    }
    
    func remove(answer messageId: String) {
        self.elements.removeAll(where: { element -> Bool in
            switch element {
            case .answer(let element):
                return element.message.messageId == messageId
            default:
                return false
            }
        })
        
        reloadData()
        
        didChangeElementsCountTrigger.accept(elements.count)
    }
    
    func loading(waitAnswer: Bool) {
        if waitAnswer {
            elements.append(.loading)
        } else {
            elements.removeAll(where: { element -> Bool in
                switch element {
                case .loading:
                    return true
                default:
                    return false
                }
            })
        }
        
        reloadData()
        
        didChangeElementsCountTrigger.accept(elements.count)
    }
    
    var didRefresh: Signal<ChatTableAnswerElement> {
        didRefreshTrigger.asSignal()
    }
    
    var didCopy: Signal<String> {
        didCopyTrigger.asSignal()
    }
    
    var didScrollToTop: Signal<Void> {
        didScrollToTopTrigger.asSignal()
    }
    
    var didChangeElementsCount: Signal<Int> {
        didChangeElementsCountTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension ChatTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .questionImageUrl(let url):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ChatQuestionImageCell.self), for: indexPath) as! ChatQuestionImageCell
            cell.setup(url: url)
            return cell
        case .questionImage(let image):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ChatQuestionImageCell.self), for: indexPath) as! ChatQuestionImageCell
            cell.setup(image: image)
            return cell
        case .questionText(let question):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ChatQuestionTextCell.self), for: indexPath) as! ChatQuestionTextCell
            cell.setup(question: question)
            return cell
        case .loading:
            let cell =  dequeueReusableCell(withIdentifier: String(describing: ChatLoadingCell.self), for: indexPath) as! ChatLoadingCell
            cell.preloader.startAnimating()
            return cell
        case .answer(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ChatAnswerCell.self), for: indexPath) as! ChatAnswerCell
            cell.setup(text: element.message.content, refreshHidden: false)
            cell.didTapCopy = { [weak self] in
                self?.didCopyTrigger.accept(element.message.content)
            }
            cell.didTapRefresh = { [weak self] in
                self?.didRefreshTrigger.accept(element)
            }
            return cell
        case .historyAnswer(let message):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ChatAnswerCell.self), for: indexPath) as! ChatAnswerCell
            cell.setup(text: message.content, refreshHidden: true)
            cell.didTapCopy = { [weak self] in
                self?.didCopyTrigger.accept(message.content)
            }
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension ChatTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            didScrollToTopTrigger.accept(Void())
        }
    }
}

// MARK: Private
private extension ChatTableView {
    func initialize() {
        register(ChatQuestionImageCell.self, forCellReuseIdentifier: String(describing: ChatQuestionImageCell.self))
        register(ChatQuestionTextCell.self, forCellReuseIdentifier: String(describing: ChatQuestionTextCell.self))
        register(ChatLoadingCell.self, forCellReuseIdentifier: String(describing: ChatLoadingCell.self))
        register(ChatAnswerCell.self, forCellReuseIdentifier: String(describing: ChatAnswerCell.self))
        
        dataSource = self
        delegate = self
    }
}
