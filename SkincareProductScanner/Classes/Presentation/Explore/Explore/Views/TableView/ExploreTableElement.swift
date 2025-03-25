//
//  ExploreTableElement.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 17.03.2025.
//

enum ExploreTableElement {
    case recommendationsTitle
    case stgp([ExploreSTGPElement])
    case recommendationsProducts([Product])
    case bookmarks
    case catalogs
}

enum ExploreSTGPElement {
    case skinType(SkinType)
    case goal(Goal)
    case preference(Preference)
}
