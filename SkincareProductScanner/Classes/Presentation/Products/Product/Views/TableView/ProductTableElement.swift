//
//  ProductTableElement.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 03.04.2025.
//

enum ProductTableElement {
    case titleBrand(PTTitleBrandElement)
    case text(String)
    case stgp([ExploreSTGPElement])
    case titleValue(PTTitleValueElement)
    case similarProducts([Product])
}

struct PTTitleBrandElement {
    let title: String
    let brand: String
}

struct PTTitleValueElement {
    let title: String
    let value: String
}
