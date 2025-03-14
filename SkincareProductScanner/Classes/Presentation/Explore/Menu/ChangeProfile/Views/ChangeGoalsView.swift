//
//  ChangeGoalsView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 14.03.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class ChangeGoalsView: ChangeProfileFieldView {
    lazy var tableView = makeTableView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var discoveryManager = DiscoveryManager()
    private lazy var profileManager = ProfileManager()
    
    private lazy var goals = [Goal]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func makeField() -> ChangeProfileFieldView.ChangedField? {
        let selectedIds = tableView.elements
            .filter { $0.marked }
            .map { $0.id }
        let selectedGoalsIds = goals
            .filter { goal -> Bool in
                selectedIds.contains { $0 == goal.id }
            }
            .map { $0.id }
        return .goals(selectedGoalsIds)
    }
    
    override func canSave() -> Bool {
        tableView.elements.contains(where: { $0.marked })
    }
}

// MARK: Private
private extension ChangeGoalsView {
    func initialize() {
        backgroundColor = Appearance.main500
        
        tableView.didChangeSelected = { [weak self] in
            self?.updateSaveEnable()
        }
        
        let goals = discoveryManager
            .obtainGoals(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
        
        let selectedGoalsIds = profileManager
            .obtainProfile(forceUpdate: false)
            .map { $0?.goalsIds ?? [] }
            .asDriver(onErrorJustReturn: [])
        
        Driver
            .combineLatest(goals, selectedGoalsIds)
            .drive(Binder(self) { base, args in
                let (goals, selectedGoalsIds) = args
                
                base.goals = goals ?? []
                
                let elements = (goals ?? []).map {
                    OTableElement(
                        goal: $0,
                        marked: selectedGoalsIds.contains($0.id)
                    )
                }
                base.tableView.setup(elements: elements)
                
                base.updateSaveEnable()
            })
            .disposed(by: disposeBag)
        
        updateSaveEnable()
    }
}

// MARK: Make constraints
private extension ChangeGoalsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -2.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ChangeGoalsView {
    func makeTableView() -> OTableView {
        let view = OTableView()
        view.backgroundColor = UIColor.clear
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(vertical: 18.scale)
        view.setContentOffset(CGPoint(x: 0, y: -18.scale), animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
