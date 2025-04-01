//
//  ProductsFiltersViewModel.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 01.04.2025.
//

import RxSwift
import RxCocoa

final class ProductsFiltersViewModel {
    enum Action {
        case confirmClearAllFilters
        case apply(SelectedProductsFilters)
        case resetTableMarkedFilters
    }
    
    private let initialSelectedFilters: Driver<SelectedProductsFilters>
    
    private lazy var productsManager = ProductsManager()
    
    init(selectedFilters: SelectedProductsFilters) {
        self.initialSelectedFilters = BehaviorRelay(value: selectedFilters).asDriver()
    }
}

// MARK: Public
extension ProductsFiltersViewModel {
    struct Input {
        let didTapItem: Signal<PFItemElement>
        let didTapClearAllFilters: Signal<Void>
        let didConfirmClearAllFilters: Signal<Void>
        let didTapApplyFilters: Signal<Void>
    }
    
    struct Output {
        let sections: Driver<[PFTableSection]>
        let hasSelectedFilters: Driver<Bool>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        let filters = makeSelectedFilters(
            initialSelectedFilters: initialSelectedFilters,
            didTapItem: input.didTapItem,
            didConfirmClearAllFilters: input.didConfirmClearAllFilters
        )
        
        return Output(
            sections: makeSections(
                initialSelectedFilters: initialSelectedFilters,
                filters: makeFilters()
            ),
            hasSelectedFilters: filters.map { !$0.filters.isEmpty },
            action: makeAction(
                didTapClearAllFilters: input.didTapClearAllFilters,
                didTapApplyFilters: input.didTapApplyFilters,
                filters: filters,
                didConfirmClearAllFilters: input.didConfirmClearAllFilters
            )
        )
    }
}

// MARK: Private
private extension ProductsFiltersViewModel {
    func makeSelectedFilters(
        initialSelectedFilters: Driver<SelectedProductsFilters>,
        didTapItem: Signal<PFItemElement>,
        didConfirmClearAllFilters: Signal<Void>
    ) -> Driver<SelectedProductsFilters> {
        enum Action {
            case tap(PFItemElement)
            case clear
        }
        
        return initialSelectedFilters
            .flatMapLatest { initialSelectedFilters -> Driver<SelectedProductsFilters> in
                let action = Driver<Action>
                    .merge(
                        didTapItem
                            .asDriver(onErrorDriveWith: .never())
                            .map { Action.tap($0) },
                        didConfirmClearAllFilters
                            .asDriver(onErrorDriveWith: .never())
                            .map { Action.clear }
                    )
                
                return action
                    .scan(initialSelectedFilters) { current, action -> SelectedProductsFilters in
                        switch action {
                        case .tap(let item):
                            var filters = current.filters
                            
                            if let index = filters.firstIndex(where: { $0.parentFilterId == item.parentId }) {
                                let filter = filters[index]
                                
                                var itemsIds = filter.itemsIds
                                if let index = itemsIds.firstIndex(of: item.item.id) {
                                    itemsIds.remove(at: index)
                                } else {
                                    itemsIds.append(item.item.id)
                                }
                                
                                if itemsIds.isEmpty {
                                    filters.remove(at: index)
                                } else {
                                    let updatedFilter = SelectedProductsFilters.Filter(
                                        parentFilterId: filter.parentFilterId,
                                        itemsIds: itemsIds
                                    )
                                    filters[index] = updatedFilter
                                }
                            } else {
                                let newFilter = SelectedProductsFilters.Filter(
                                    parentFilterId: item.parentId,
                                    itemsIds: [item.item.id]
                                )
                                filters.append(newFilter)
                            }
                            
                            return SelectedProductsFilters(
                                filters: filters
                            )
                        case .clear:
                            return SelectedProductsFilters(filters: [])
                        }
                    }
                    .startWith(initialSelectedFilters)
            }
    }
    
    func makeSections(
        initialSelectedFilters: Driver<SelectedProductsFilters>,
        filters: Driver<[ProductFilter]>
    ) -> Driver<[PFTableSection]> {
        Driver
            .combineLatest(initialSelectedFilters, filters)
            .map { initialSelectedFilters, filters -> [PFTableSection] in
                filters.map { filter -> PFTableSection in
                    let allSelectedItemsIds = initialSelectedFilters.filters
                        .reduce([]) { $0 + $1.itemsIds }
                    
                    let sectionElement = PFSectionElement(
                        name: filter.name,
                        opened: false
                    )
                    
                    let itemsElements = filter.items.map { item -> PFTableElement in
                        let element = PFItemElement(
                            item: item,
                            parentId: filter.id,
                            marked: allSelectedItemsIds.contains(item.id)
                        )
                        return .item(element)
                    }
                    
                    return PFTableSection(
                        openedElements: [.section(sectionElement)] + itemsElements,
                        closedElements: [.section(sectionElement)],
                        opened: false
                    )
                }
            }
    }
    
    func makeFilters() -> Driver<[ProductFilter]> {
        productsManager
            .obtainFilters(forceUpdate: false)
            .compactMap { $0?.filters }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeAction(
        didTapClearAllFilters: Signal<Void>,
        didTapApplyFilters: Signal<Void>,
        filters: Driver<SelectedProductsFilters>,
        didConfirmClearAllFilters: Signal<Void>
    ) -> Driver<Action> {
        let confirmClearAllFilters = didTapClearAllFilters
            .map { Action.confirmClearAllFilters }
            .asDriver(onErrorDriveWith: .never())
        
        let resetTableMarked = didConfirmClearAllFilters
            .map { Action.resetTableMarkedFilters }
            .asDriver(onErrorDriveWith: .never())
        
        let apply = didTapApplyFilters
            .withLatestFrom(filters)
            .map { Action.apply($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(confirmClearAllFilters, resetTableMarked, apply)
    }
}
