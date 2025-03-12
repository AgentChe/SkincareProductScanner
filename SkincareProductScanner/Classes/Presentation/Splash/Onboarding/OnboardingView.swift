//
//  OnboardingView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

final class OnboardingView: UIView {
    enum Slide: Int, CaseIterable {
        case disclaimer
        case scanInfo
        case curatedLists
        case skinTypes
        case goals
        case preferences
    }
    
    lazy var container = makeContainer()
    lazy var headerView = makeHeaderView()
    
    private lazy var slidesViews: [Slide: UIView] = [
        .disclaimer: ODisclaimerView { [weak self] in
            self?.scroll(from: .disclaimer, to: .scanInfo)
        },
        .scanInfo: OScanInfoView(didTapNext: { [weak self] in
            self?.scroll(from: .scanInfo, to: .curatedLists)
        }, didTapDisclaimer: { [weak self] in
            let vc = OnboardingDisclaimerViewController.make()
            self?.vc?.present(vc, animated: false)
        }),
        .curatedLists: OCuratedListsView(didTapNext: { [weak self] in
            self?.scroll(from: .curatedLists, to: .skinTypes)
        }, didTapDisclaimer: { [weak self] in
            let vc = OnboardingDisclaimerViewController.make()
            self?.vc?.present(vc, animated: false)
        }),
        .skinTypes: OSkinTypesView(didTapNext: { [weak self] skinTypesIds in
            self?.collector.setup(skinTypesIds: skinTypesIds)
            self?.scroll(from: .skinTypes, to: .goals)
        }, didTapDisclaimer: { [weak self] in
            let vc = OnboardingDisclaimerViewController.make()
            self?.vc?.present(vc, animated: false)
        }),
        .goals: OGoalsView(didTapNext: { [weak self] goalsIds in
            self?.collector.setup(goalsIds: goalsIds)
            self?.scroll(from: .goals, to: .preferences)
        }, didTapDisclaimer: { [weak self] in
            let vc = OnboardingDisclaimerViewController.make()
            self?.vc?.present(vc, animated: false)
        }),
        .preferences: OPreferencesView(didTapNext: { [weak self] preferencesIds in
            guard let self else { return }
            
            collector.setup(preferencesIds: preferencesIds)
            finish(collector.make())
        }, didTapDisclaimer: { [weak self] in
            let vc = OnboardingDisclaimerViewController.make()
            self?.vc?.present(vc, animated: false)
        })
    ]
    
    private var currentSlide = Slide.disclaimer
    
    private lazy var collector = OProfileCollector()
    
    private weak var vc: UIViewController?
    private let finish: (Profile) -> Void
    
    init(vc: UIViewController?, finish: @escaping (Profile) -> Void) {
        self.vc = vc
        self.finish = finish
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        slidesViews.map { $1 }.forEach { slideView in
            slideView.frame.size = container.bounds.size
        }
    }
}

// MARK: Private
private extension OnboardingView {
    func initialize() {
        backgroundColor = Appearance.mono200
        
        headerView.didTapBack = { [weak self] in
            guard let self else { return }
            
            let previousSlideIndex = currentSlide.rawValue - 1
            
            guard let previousSlide = Slide(rawValue: previousSlideIndex) else { return }
            
            scroll(from: currentSlide, to: previousSlide)
        }
        
        if let view = slidesViews[.disclaimer] {
            view.frame.origin = CGPoint.zero
            container.addSubview(view)
        }
        
        headerView.setup(slide: .disclaimer)
    }
    
    func scroll(from: Slide, to: Slide) {
        guard let currentView = slidesViews[from], let scrollToView = slidesViews[to] else { return }
        
        let direction = to.rawValue > from.rawValue ? 1 : -1
        
        scrollToView.frame.origin = CGPoint(x: bounds.size.width * CGFloat(direction), y: 0)
        
        container.addSubview(scrollToView)
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self else { return }
            
            currentView.frame.origin = CGPoint(x: bounds.size.width * CGFloat(-direction), y: 0)
            scrollToView.frame.origin = CGPoint(x: 0, y: 0)
        }, completion: { [weak self] result in
            guard let self = self else { return }
            
            currentView.removeFromSuperview()
            
            headerView.setup(slide: to)
            
            currentSlide = to
        })
    }
}

// MARK: Make constraints
private extension OnboardingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 35.scale),
            headerView.heightAnchor.constraint(equalToConstant: 24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OnboardingView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeHeaderView() -> OnboardingHeaderView {
        let view = OnboardingHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
