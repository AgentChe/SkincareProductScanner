//
//  OGoalsView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 12.03.2025.
//

import UIKit
import RxSwift

final class OGoalsView: UIView {
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var tableView = makeTableView()
    lazy var nextButton = makeNextButton()
    lazy var disclaimerButton = makeDisclaimerButton()
    
    private lazy var discoveryManager = DiscoveryManager()
    
    private lazy var disposeBag = DisposeBag()
    
    private var didTapNext: ([String]) -> Void
    private var didTapDisclaimer: () -> Void
    
    init(
        didTapNext: @escaping ([String]) -> Void,
        didTapDisclaimer: @escaping () -> Void
    ) {
        self.didTapNext = didTapNext
        self.didTapDisclaimer = didTapDisclaimer
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        changeNextEnable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OGoalsView {
    func initialize() {
        backgroundColor = Appearance.main500
        
        tableView.didChangeSelected = { [weak self] in
            self?.changeNextEnable()
        }
        
        let goals = discoveryManager
            .obtainGoals(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
        
        goals
            .drive(Binder(tableView) { base, goals in
                let elements = (goals ?? []).map { OTableElement(goal: $0) }
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(goals)
            .drive(Binder(self) { base, goals in
                let selectedIds = base.tableView.elements
                    .filter { $0.marked }
                    .map { $0.id }
                let selectedGoalsIds = (goals ?? [])
                    .filter { goal -> Bool in
                        selectedIds.contains { $0 == goal.id }
                    }
                    .map { $0.id }
                base.didTapNext(selectedGoalsIds)
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func disclaimerButtonTapped() {
        didTapDisclaimer()
    }
    
    func changeNextEnable() {
        let marked = tableView.elements.contains(where: { $0.marked })
        nextButton.isHidden = !marked
    }
}

// MARK: Make constraints
private extension OGoalsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 449.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 90.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: 98.scale),
            nextButton.heightAnchor.constraint(equalToConstant: 54.scale),
            nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: disclaimerButton.topAnchor, constant: -19.scale)
        ])
        
        NSLayoutConstraint.activate([
            disclaimerButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            disclaimerButton.heightAnchor.constraint(equalToConstant: 23.scale),
            disclaimerButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -19.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OGoalsView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Onboarding.Lists")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.bold(size: 22.scale))
            .lineHeight(30.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Goals.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> OTableView {
        let view = OTableView()
        view.backgroundColor = UIColor.clear
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(vertical: 38.scale)
        view.setContentOffset(CGPoint(x: 0, y: -38.scale), animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNextButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Outfit.medium(size: 18.scale))
        
        let view = UIButton()
        view.backgroundColor = Appearance.main700
        view.layer.cornerRadius = 12.scale
        view.setAttributedTitle("Next".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDisclaimerButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.4))
            .font(Fonts.Outfit.medium(size: 18.scale))
        
        let view = TapAreaButton()
        view.setAttributedTitle("Onboarding.DisclaimerInfo".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(disclaimerButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
