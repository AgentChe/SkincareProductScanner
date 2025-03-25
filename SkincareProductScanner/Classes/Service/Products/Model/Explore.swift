//
//  Explore.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 22.03.2025.
//

struct Explore {
    let recommendation: ExploreRecommendation
    let productsCategories: [ProductCategory]
    
    init(
        recommendation: ExploreRecommendation,
        productsCategories: [ProductCategory]
    ) {
        self.recommendation = recommendation
        self.productsCategories = productsCategories
    }
    
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any]
        else { return nil }
        
        recommendation = {
            guard let json = body["recommendation"] as? [String: Any] else {
                return ExploreRecommendation()
            }
            return ExploreRecommendation(json: json)
        }()
        productsCategories = {
            guard let array = body["popularity"] as? [[String: Any]] else { return [] }
            return array.compactMap { ProductCategory(json: $0) }
        }()
    }
}

struct ExploreRecommendation {
    let profile: ExploreRecommendationProfile
    let products: [Product]
    
    init(
        profile: ExploreRecommendationProfile,
        products: [Product]
    ) {
        self.profile = profile
        self.products = products
    }
    
    init() {
        profile = ExploreRecommendationProfile()
        products = []
    }
    
    init(json: [String: Any]) {
        profile = {
            guard let profileJSON = json["profile"] as? [String: Any] else {
                return ExploreRecommendationProfile()
            }
            return ExploreRecommendationProfile(json: profileJSON)
        }()
        products = {
            guard let array = json["items"] as? [[String: Any]] else { return [] }
            return array.compactMap { Product(json: $0) }
        }()
    }
}

struct ExploreRecommendationProfile {
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
