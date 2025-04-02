//
//  AllProductsTableElement.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 01.04.2025.
//

import Foundation

final class APTableSection {
    let openedElements: [APTableElement]
    let closedElements: [APTableElement]
    var opened: Bool
    
    init(
        openedElements: [APTableElement],
        closedElements: [APTableElement],
        opened: Bool
    ) {
        self.openedElements = openedElements
        self.closedElements = closedElements
        self.opened = opened
    }
}

enum APTableElement {
    case presetSection(APPresetSectionElement)
    case presetItem(String)
    case product(Product)
}

final class APPresetSectionElement {
    let image: URL
    let name: String
    var opened: Bool
    
    init(image: URL, name: String, opened: Bool) {
        self.image = image
        self.name = name
        self.opened = opened
    }
}
