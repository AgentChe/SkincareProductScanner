//
//  ProductDetails.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 24.03.2025.
//

import Foundation

struct ProductDetails {
    let id: String
    let image: URL
    let title: String
    let brand: String
    let favorite: Bool
    let description: String?
    let tailoredForYou: ProductTailoredForYou
    let keyIngredients: [String]?
    let ingredients: [String]
    let freeForm: [String]?
    let apply: String?
    let similar: [Product]
    
    init(
        id: String,
        image: URL,
        title: String,
        brand: String,
        favorite: Bool,
        description: String?,
        tailoredForYou: ProductTailoredForYou,
        keyIngredients: [String]?,
        ingredients: [String],
        freeForm: [String]?,
        apply: String?,
        similar: [Product]
    ) {
        self.id = id
        self.image = image
        self.title = title
        self.brand = brand
        self.favorite = favorite
        self.description = description
        self.tailoredForYou = tailoredForYou
        self.keyIngredients = keyIngredients
        self.ingredients = ingredients
        self.freeForm = freeForm
        self.apply = apply
        self.similar = similar
    }
    
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let id = body["id"] as? String,
            let image: URL = {
                guard let string = body["image"] as? String else { return nil }
                return URL(string: string)
            }(),
            let title = body["title"] as? String,
            let brand = body["brand"] as? String,
            let favorite = body["is_favorite"] as? Bool,
            let ingredients = body["ingredients"] as? [String]
        else { return nil }
        
        self.id = id
        self.image = image
        self.title = title
        self.brand = brand
        self.favorite = favorite
        self.description = body["description"] as? String
        self.tailoredForYou = {
            let json = body["for_you"] as? [String: Any] ?? [:]
            return ProductTailoredForYou(json: json)
        }()
        self.keyIngredients = body["key_ingredients"] as? [String]
        self.ingredients = ingredients
        self.freeForm = body["free_form"] as? [String]
        self.apply = body["apply"] as? String
        self.similar = {
            guard let array = body["similar"] as? [[String: Any]] else { return [] }
            return array.compactMap { Product(json: $0) }
        }()
    }
}

struct ProductTailoredForYou {
    let skinTypes: [SkinType]
    let goals: [Goal]
    let preferences: [Preference]
    
    init(
        skinTypes: [SkinType],
        goals: [Goal],
        preferences: [Preference]
    ) {
        self.skinTypes = skinTypes
        self.goals = goals
        self.preferences = preferences
    }
    
    init() {
        skinTypes = []
        goals = []
        preferences = []
    }
    
    init(json: [String: Any]) {
        skinTypes = {
            guard let array = json["skin_types"] as? [[String: Any]] else { return [] }
            return array.compactMap { SkinType(json: $0)}
        }()
        goals = {
            guard let array = json["goals"] as? [[String: Any]] else { return [] }
            return array.compactMap { Goal(json: $0)}
        }()
        preferences = {
            guard let array = json["preferences"] as? [[String: Any]] else { return [] }
            return array.compactMap { Preference(json: $0)}
        }()
    }
}
