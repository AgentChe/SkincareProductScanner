//
//  SelectedProductsFilters.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 01.04.2025.
//

struct SelectedProductsFilters {
    struct Filter {
        let parentFilterId: String
        let itemsIds: [String]
    }
    
    let filters: [Filter]
}
