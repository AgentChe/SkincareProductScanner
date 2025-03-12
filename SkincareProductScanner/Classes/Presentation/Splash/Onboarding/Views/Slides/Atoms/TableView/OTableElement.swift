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
    
    init(skinType: SkinType) {
        self.id = skinType.id
        self.name = skinType.name
        self.marked = false
    }
    
    init(goal: Goal) {
        self.id = goal.id
        self.name = goal.name
        self.marked = false
    }
    
    init(preference: Preference) {
        self.id = preference.id
        self.name = preference.name
        self.marked = false
    }
}
