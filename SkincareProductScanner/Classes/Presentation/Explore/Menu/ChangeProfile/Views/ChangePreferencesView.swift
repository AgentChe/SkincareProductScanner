//
//  ChangePreferencesView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 14.03.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class ChangePreferencesView: ChangeProfileFieldView {
    lazy var tableView = makeTableView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var discoveryManager = DiscoveryManager()
    private lazy var profileManager = ProfileManager()
    
    private lazy var preferences = [Preference]()
    
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
        let selectedPreferencesIds = preferences
            .filter { preference -> Bool in
                selectedIds.contains { $0 == preference.id }
            }
            .map { $0.id }
        return .preferences(selectedPreferencesIds)
    }
    
    override func canSave() -> Bool {
        tableView.elements.contains(where: { $0.marked })
    }
}

// MARK: Private
private extension ChangePreferencesView {
    func initialize() {
        backgroundColor = Appearance.main500
        
        tableView.didChangeSelected = { [weak self] in
            self?.updateSaveEnable()
        }
        
        let preferences = discoveryManager
            .obtainPreferences(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
        
        let selectedPreferencesIds = profileManager
            .obtainProfile(forceUpdate: false)
            .map { $0?.preferencesIds ?? [] }
            .asDriver(onErrorJustReturn: [])
        
        Driver
            .combineLatest(preferences, selectedPreferencesIds)
            .drive(Binder(self) { base, args in
                let (preferences, selectedPreferencesIds) = args
                
                base.preferences = preferences ?? []
                
                let elements = (preferences ?? []).map {
                    OTableElement(
                        preference: $0,
                        marked: selectedPreferencesIds.contains($0.id)
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
private extension ChangePreferencesView {
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
private extension ChangePreferencesView {
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
