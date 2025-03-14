//
//  OTableElement.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 12.03.2025.
//

final class OTableElement {
    let id: String
    let name: String
    var marked: Bool
    
    init(skinType: SkinType, marked: Bool = false) {
        self.id = skinType.id
        self.name = skinType.name
        self.marked = marked
    }
    
    init(goal: Goal, marked: Bool = false) {
        self.id = goal.id
        self.name = goal.name
        self.marked = marked
    }
    
    init(preference: Preference, marked: Bool = false) {
        self.id = preference.id
        self.name = preference.name
        self.marked = marked
    }
}
