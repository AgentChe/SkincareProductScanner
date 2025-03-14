//
//  MenuTableElement.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 14.03.2025.
//

struct MenuTableElement {
    enum Route {
        case profileEntity(MenuTableProfileEntityElement)
        case info(MenuTableInfoElement)
        case url(MenuTableURLElement)
    }
    
    let route: Route
    let separatorHidden: Bool
    
    init(route: Route, separatorHidden: Bool = false) {
        self.route = route
        self.separatorHidden = separatorHidden
    }
}

enum MenuTableProfileEntityElement {
    case skinType
    case goals
    case preferences
}

enum MenuTableInfoElement {
    case disclaimer
    case references
}

enum MenuTableURLElement {
    case termsOfUse
    case privacyPolicy
    case support
}
