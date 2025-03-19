//
//  BookmarksCoordinator.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 19.03.2025.
//

import UIKit

final class BookmarksCoordinator {
    private weak var parentVC: UIViewController?
    private weak var container: UIView?
    
    lazy var productsVC = UIViewController() // TODO
    lazy var proceduresVC = BookmarksCatalogsViewController.make(entity: .procedures)
    lazy var glossaryVC = BookmarksCatalogsViewController.make(entity: .glossary)
    
    private var previousVC: UIViewController?
    
    init(parentVC: UIViewController, container: UIView?) {
        self.parentVC = parentVC
        self.container = container
    }
    
    func change(entity: BookmarksEntityButton.Entity) {
        switch entity {
        case .products:
            changeVC(on: productsVC)
        case .procedures:
            changeVC(on: proceduresVC)
        case .glossary:
            changeVC(on: glossaryVC)
        }
    }
}

// MARK: Private
private extension BookmarksCoordinator {
    func changeVC(on vc: UIViewController) {
        if let previousVC = self.previousVC {
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
        }
    
        self.previousVC = vc
        
        guard let parentVC, let container else {
            return
        }
    
        parentVC.addChild(vc)
        vc.view.frame = container.bounds
        container.addSubview(vc.view)
        vc.willMove(toParent: parentVC)
    }
}
