//
//  ExploreTableView.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 17.03.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class ExploreTableView: UITableView {
    private lazy var elements = [ExploreTableElement]()
    
    private lazy var didTapSeeAllRecommendationsTrigger = PublishRelay<Void>()
    private lazy var didSelectProductTrigger = PublishRelay<Product>()
    private lazy var didTapBookmarksTrigger = PublishRelay<Void>()
    private lazy var didTapAllProductsTrigger = PublishRelay<Void>()
    private lazy var didTapProceduresTrigger = PublishRelay<Void>()
    private lazy var didTapGlossaryTrigger = PublishRelay<Void>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ExploreTableView {
    func setup(elements: [ExploreTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didTapSeeAllRecommendations: Signal<Void> {
        didTapSeeAllRecommendationsTrigger.asSignal()
    }
    
    var didSelectProduct: Signal<Product> {
        didSelectProductTrigger.asSignal()
    }
    
    var didTapBookmarks: Signal<Void> {
        didTapBookmarksTrigger.asSignal()
    }
    
    var didTapAllProducts: Signal<Void> {
        didTapAllProductsTrigger.asSignal()
    }
    
    var didTapProcedures: Signal<Void> {
        didTapProceduresTrigger.asSignal()
    }
    
    var didTapGlossary: Signal<Void> {
        didTapGlossaryTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension ExploreTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .recommendationsTitle:
            let cell = dequeueReusableCell(withIdentifier: String(describing: ExploreTableRecommendationsTitleCell.self), for: indexPath) as! ExploreTableRecommendationsTitleCell
            cell.didTapSeeAll = { [weak self] in
                self?.didTapSeeAllRecommendationsTrigger.accept(Void())
            }
            return cell
        case .stgp(let elements):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ExploreTableSTGPCell.self), for: indexPath) as! ExploreTableSTGPCell
            cell.collectionView.setup(elements: elements)
            return cell
        case .recommendationsProducts(let elements):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ExploreTableRecommendationsProductsCell.self), for: indexPath) as! ExploreTableRecommendationsProductsCell
            cell.collectionView.setup(elements: elements)
            cell.collectionView.didSelect = { [weak self] product in
                self?.didSelectProductTrigger.accept(product)
            }
            return cell
        case .bookmarks:
            return dequeueReusableCell(withIdentifier: String(describing: ExploreTableBookmarksCell.self), for: indexPath)
        case .catalogs:
            let cell = dequeueReusableCell(withIdentifier: String(describing: ExploreTableCatalogsCell.self), for: indexPath) as! ExploreTableCatalogsCell
            cell.didTapAllProducts = { [weak self] in
                self?.didTapAllProductsTrigger.accept(Void())
            }
            cell.didTapProcedures = { [weak self] in
                self?.didTapProceduresTrigger.accept(Void())
            }
            cell.didTapGlossary = { [weak self] in
                self?.didTapGlossaryTrigger.accept(Void())
            }
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension ExploreTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .bookmarks:
            didTapBookmarksTrigger.accept(Void())
        default:
            return 
        }
    }
}

// MARK: Private
private extension ExploreTableView {
    func initialize() {
        register(ExploreTableRecommendationsTitleCell.self, forCellReuseIdentifier: String(describing: ExploreTableRecommendationsTitleCell.self))
        register(ExploreTableSTGPCell.self, forCellReuseIdentifier: String(describing: ExploreTableSTGPCell.self))
        register(ExploreTableRecommendationsProductsCell.self, forCellReuseIdentifier: String(describing: ExploreTableRecommendationsProductsCell.self))
        register(ExploreTableBookmarksCell.self, forCellReuseIdentifier: String(describing: ExploreTableBookmarksCell.self))
        register(ExploreTableCatalogsCell.self, forCellReuseIdentifier: String(describing: ExploreTableCatalogsCell.self))
        
        dataSource = self
        delegate = self
    }
}
