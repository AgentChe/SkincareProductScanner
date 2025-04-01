//
//  PFTableElement.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 01.04.2025.
//

final class PFTableSection {
    let openedElements: [PFTableElement]
    let closedElements: [PFTableElement]
    var opened: Bool
    
    init(
        openedElements: [PFTableElement],
        closedElements: [PFTableElement],
        opened: Bool
    ) {
        self.openedElements = openedElements
        self.closedElements = closedElements
        self.opened = opened
    }
}

enum PFTableElement {
    case section(PFSectionElement)
    case item(PFItemElement)
}

final class PFSectionElement {
    let name: String
    var opened: Bool
    
    init(name: String, opened: Bool) {
        self.name = name
        self.opened = opened
    }
}

final class PFItemElement {
    let item: ProductFilterItem
    let parentId: String
    var marked: Bool
    
    init(
        item: ProductFilterItem,
        parentId: String,
        marked: Bool
    ) {
        self.item = item
        self.parentId = parentId
        self.marked = marked
    }
}
