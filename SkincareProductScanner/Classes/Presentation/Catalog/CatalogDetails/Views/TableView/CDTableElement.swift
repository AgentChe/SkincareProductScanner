//
//  CDTableElement.swift
//  ScinCare
//
//  Created by Андрей Чернышев on 23.10.2024.
//

import Foundation

final class CDTableSection {
    var opened: Bool
    let openedElements: [CDTableElement]
    let closedElements: [CDTableElement]
    
    init(
        opened: Bool,
        openedElements: [CDTableElement],
        closedElements: [CDTableElement]
    ) {
        self.opened = opened
        self.openedElements = openedElements
        self.closedElements = closedElements
    }
}

enum CDTableElement {
    case name(String)
    case section(CDSectionElement)
    case title(String)
    case text(String)
    case image(URL)
    case separator
}

final class CDSectionElement {
    let name: String
    var opened: Bool
    
    init(name: String, opened: Bool) {
        self.name = name
        self.opened = opened
    }
}
