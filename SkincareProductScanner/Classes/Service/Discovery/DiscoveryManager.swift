//
//  DiscoveryManager.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 11.03.2025.
//

import RxSwift

protocol DiscoveryManagerProtocol {
    func obtainSkinTypes(forceUpdate: Bool) -> Single<[SkinType]?>
    func obtainGoals(forceUpdate: Bool) -> Single<[Goal]?>
    func obtainPreferences(forceUpdate: Bool) -> Single<[Preference]?>
}

final class DiscoveryManager {
    private lazy var restApiTransport = RestAPITransport()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: DiscoveryManagerProtocol
extension DiscoveryManager: DiscoveryManagerProtocol {
    func obtainSkinTypes(forceUpdate: Bool) -> Single<[SkinType]?> {
        forceUpdate ? loadSkinTypes() : cachedSkinTypes()
    }
    
    func obtainGoals(forceUpdate: Bool) -> Single<[Goal]?> {
        forceUpdate ? loadGoals() : cachedGoals()
    }
    
    func obtainPreferences(forceUpdate: Bool) -> Single<[Preference]?> {
        forceUpdate ? loadPreferences() : cachedPreferences()
    }
}

// MARK: Private
private extension DiscoveryManager {
    enum Constants {
        static let skinTypesKey = "dm_skin_types"
        static let goalsKey = "dm_goals"
        static let preferencesKey = "dm_preferences"
    }
    
    // TODO
    func loadSkinTypes() -> Single<[SkinType]?> {
//        let request = ObtainSkinTypesRequest(
//            anonymousId: sessionManager.anonymousId,
//            internalId: sessionManager.internalId
//        )
//        
//        return restApiTransport
//            .callServerApi(requestBody: request)
//            .map { SkinType.map(response: $0) }
//            .do(onSuccess: { skinTypes in
//                guard let skinTypes, let data = try? JSONEncoder().encode(skinTypes) else { return }
//                
//                UserDefaults.standard.set(data, forKey: Constants.skinTypesKey)
//            })
        
        Single<[SkinType]?>
            .create { single in
                let strings = [
                    "Normal",
                    "City",
                    "Dry",
                    "Combination",
                    "Sensitive"
                ]
                let skinTypes = strings.enumerated()
                    .map { index, string in
                        SkinType(id: String(index), name: string)
                    }
                
                single(.success(skinTypes))
                
                return Disposables.create()
            }
            .do(onSuccess: { skinTypes in
                guard let skinTypes, let data = try? JSONEncoder().encode(skinTypes) else { return }

                UserDefaults.standard.set(data, forKey: Constants.skinTypesKey)
            })
    }
    
    func cachedSkinTypes() -> Single<[SkinType]?> {
        Single<[SkinType]?>.create { single in
            let skinTypes: [SkinType]? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.skinTypesKey) else { return nil }
                return try? JSONDecoder().decode([SkinType].self, from: data)
            }()
            
            single(.success(skinTypes))
            
            return Disposables.create()
        }
    }
    
    // TODO
    func loadGoals() -> Single<[Goal]?> {
//        let request = ObtainGoalsRequest(
//            anonymousId: sessionManager.anonymousId,
//            internalId: sessionManager.internalId
//        )
//        
//        return restApiTransport
//            .callServerApi(requestBody: request)
//            .map { Goal.map(response: $0) }
//            .do(onSuccess: { goals in
//                guard let goals, let data = try? JSONEncoder().encode(goals) else { return }
//                
//                UserDefaults.standard.set(data, forKey: Constants.goalsKey)
//            })
        
        Single<[Goal]?>
            .create { single in
                let strings = [
                    "Hydration",
                    "Reduce acne",
                    "Even skin tone",
                    "Anti-aging",
                    "Soothe sensitive skin",
                    "Sun protection",
                    "Deep cleansing"
                ]
                let goals = strings.enumerated()
                    .map { index, string in
                        Goal(id: String(index), name: string)
                    }
                
                single(.success(goals))
                
                return Disposables.create()
            }
            .do(onSuccess: { goals in
                guard let goals, let data = try? JSONEncoder().encode(goals) else { return }

                UserDefaults.standard.set(data, forKey: Constants.goalsKey)
            })
    }
    
    func cachedGoals() -> Single<[Goal]?> {
        Single<[Goal]?>.create { single in
            let goals: [Goal]? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.goalsKey) else { return nil }
                return try? JSONDecoder().decode([Goal].self, from: data)
            }()
            
            single(.success(goals))
            
            return Disposables.create()
        }
    }
    
    // TODO
    func loadPreferences() -> Single<[Preference]?> {
//        let request = ObtainPreferencesRequest(
//            anonymousId: sessionManager.anonymousId,
//            internalId: sessionManager.internalId
//        )
//        
//        return restApiTransport
//            .callServerApi(requestBody: request)
//            .map { Preference.map(response: $0) }
//            .do(onSuccess: { preferences in
//                guard let preferences, let data = try? JSONEncoder().encode(preferences) else { return }
//                
//                UserDefaults.standard.set(data, forKey: Constants.preferencesKey)
//            })
        
        Single<[Preference]?>
            .create { single in
                let strings = [
                    "Vegan",
                    "Cruelty Free",
                    "EU-Allergen Free",
                    "Reef Safe",
                    "Malassezia Safe",
                    "Alcohol Free",
                    "Silicone Free",
                    "Fragrance Free",
                    "Sulfate Free",
                    "Paraben Free",
                    "Oil Free",
                    "Non-Comedogenic",
                    "Fatty Alcohol Free"
                ]
                let preferences = strings.enumerated()
                    .map { index, string in
                        Preference(id: String(index), name: string)
                    }
                
                single(.success(preferences))
                
                return Disposables.create()
            }
            .do(onSuccess: { preferences in
                guard let preferences, let data = try? JSONEncoder().encode(preferences) else { return }

                UserDefaults.standard.set(data, forKey: Constants.preferencesKey)
            })
    }
    
    func cachedPreferences() -> Single<[Preference]?> {
        Single<[Preference]?>.create { single in
            let preferences: [Preference]? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.preferencesKey) else { return nil }
                return try? JSONDecoder().decode([Preference].self, from: data)
            }()
            
            single(.success(preferences))
            
            return Disposables.create()
        }
    }
}
