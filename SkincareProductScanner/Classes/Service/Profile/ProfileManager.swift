//
//  ProfileManager.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 06.09.2024.
//

import RxSwift
import RxCocoa

protocol ProfileManagerProtocol: AnyObject {
    func create() -> Single<Void>
    func binding() -> Single<Void>
    func dermatologySyncTokens() -> Single<Void>
    func dermatologyLogin() -> Single<Void>
    func setup(profile: Profile) -> Single<RequestResult>
    func update(skinTypesIds: [String]) -> Single<RequestResult>
    func update(goalsIds: [String]) -> Single<RequestResult>
    func update(preferencesIds: [String]) -> Single<RequestResult>
    func obtainProfile(forceUpdate: Bool) -> Single<Profile?>
}

final class ProfileManager {
    private lazy var restApiTransport = RestAPITransport()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: ProfileManagerProtocol
extension ProfileManager: ProfileManagerProtocol {
    func create() -> Single<Void> {
        let request = ProfileCreateRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func binding() -> Single<Void> {
        let request = ProfileBindingRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func dermatologySyncTokens() -> Single<Void> {
        let request = DermatologySyncTokensRequest(
            oldToken: sessionManager.anonymousId,
            newToken: sessionManager.internalId
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func dermatologyLogin() -> Single<Void> {
        let request = DermatologyLoginRequest(userToken: sessionManager.internalId)
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func setup(profile: Profile) -> Single<RequestResult> {
        let request = SetProfileRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            skinTypesIds: profile.skinTypesIds,
            goalsIds: profile.goalsIds,
            preferencesIds: profile.preferencesIds
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { [weak self] result in
                guard result.success else { return }
                
                self?.store(profile: profile, notify: true)
            })
    }
    
    func update(skinTypesIds: [String]) -> Single<RequestResult> {
        cachedProfile()
            .flatMap { [weak self] profile -> Single<RequestResult> in
                guard let self else { return .never() }
                
                let request = SetProfileRequest(
                    anonymousId: sessionManager.anonymousId,
                    internalId: sessionManager.internalId,
                    skinTypesIds: skinTypesIds,
                    goalsIds: profile.goalsIds,
                    preferencesIds: profile.preferencesIds
                )
                
                return restApiTransport
                    .callServerApi(requestBody: request)
                    .map { RequestResult.map(response: $0) }
                    .do(onSuccess: { [weak self] result in
                        guard result.success else { return }
                        
                        self?.store(skinTypesIds: skinTypesIds)
                    })
            }
    }
    
    func update(goalsIds: [String]) -> Single<RequestResult> {
        cachedProfile()
            .flatMap { [weak self] profile -> Single<RequestResult> in
                guard let self else { return .never() }
                
                let request = SetProfileRequest(
                    anonymousId: sessionManager.anonymousId,
                    internalId: sessionManager.internalId,
                    skinTypesIds: profile.skinTypesIds,
                    goalsIds: goalsIds,
                    preferencesIds: profile.preferencesIds
                )
                
                return restApiTransport
                    .callServerApi(requestBody: request)
                    .map { RequestResult.map(response: $0) }
                    .do(onSuccess: { [weak self] result in
                        guard result.success else { return }
                        
                        self?.store(goalsIds: goalsIds)
                    })
            }
    }
    
    func update(preferencesIds: [String]) -> Single<RequestResult> {
        cachedProfile()
            .flatMap { [weak self] profile -> Single<RequestResult> in
                guard let self else { return .never() }
                
                let request = SetProfileRequest(
                    anonymousId: sessionManager.anonymousId,
                    internalId: sessionManager.internalId,
                    skinTypesIds: profile.skinTypesIds,
                    goalsIds: profile.goalsIds,
                    preferencesIds: preferencesIds
                )
                
                return restApiTransport
                    .callServerApi(requestBody: request)
                    .map { RequestResult.map(response: $0) }
                    .do(onSuccess: { [weak self] result in
                        guard result.success else { return }
                        
                        self?.store(preferencesIds: preferencesIds)
                    })
            }
    }
    
    func obtainProfile(forceUpdate: Bool) -> Single<Profile?> {
        forceUpdate ? loadProfile() : cachedProfile().map { profile -> Profile? in profile }
    }
}

// MARK: Private
private extension ProfileManager {
    enum Constants {
        static let skinTypesIds = "pm_skin_types_ids"
        static let goalsIds = "pm_goals_ids"
        static let preferencesIds = "pm_preferences_ids"
    }
   
    func loadProfile() -> Single<Profile?> {
        let request = ObtainProfileRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { Profile(response: $0) }
            .do(onSuccess: { [weak self] profile in
                guard let profile else { return }
                
                self?.store(profile: profile, notify: false)
            })
    }
    
    func cachedProfile() -> Single<Profile> {
        Single<Profile>.create { single in
            let skinTypesIds: [String]? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.skinTypesIds) else { return nil }
                return try? JSONDecoder().decode([String].self, from: data)
            }()
            let goalsIds: [String]? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.goalsIds) else { return nil }
                return try? JSONDecoder().decode([String].self, from: data)
            }()
            let preferencesIds: [String]? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.preferencesIds) else { return nil }
                return try? JSONDecoder().decode([String].self, from: data)
            }()
            
            let profile = Profile(
                skinTypesIds: skinTypesIds,
                goalsIds: goalsIds,
                preferencesIds: preferencesIds
            )
            
            single(.success(profile))
            
            return Disposables.create()
        }
    }
    
    func store(profile: Profile, notify: Bool) {
        let skinTypesIds: Data? = {
            guard let skinTypesIds = profile.skinTypesIds else { return nil }
            return try? JSONEncoder().encode(skinTypesIds)
        }()
        let goalsIds: Data? = {
            guard let goalsIds = profile.goalsIds else { return nil }
            return try? JSONEncoder().encode(goalsIds)
        }()
        let preferencesIds: Data? = {
            guard let preferencesIds = profile.preferencesIds else { return nil }
            return try? JSONEncoder().encode(preferencesIds)
        }()
        
        UserDefaults.standard.set(skinTypesIds, forKey: Constants.skinTypesIds)
        UserDefaults.standard.set(goalsIds, forKey: Constants.goalsIds)
        UserDefaults.standard.set(preferencesIds, forKey: Constants.preferencesIds)
        
        if notify {
            ProfileMediator.shared.update(profile: profile)
        }
    }
    
    func store(skinTypesIds: [String]) {
        guard let data = try? JSONEncoder().encode(skinTypesIds) else { return }
        
        UserDefaults.standard.set(data, forKey: Constants.skinTypesIds)
        
        ProfileMediator.shared.update(skinTypesIds: skinTypesIds)
    }
    
    func store(goalsIds: [String]) {
        guard let data = try? JSONEncoder().encode(goalsIds) else { return }
        
        UserDefaults.standard.set(data, forKey: Constants.goalsIds)
        
        ProfileMediator.shared.update(goalsIds: goalsIds)
    }
    
    func store(preferencesIds: [String]) {
        guard let data = try? JSONEncoder().encode(preferencesIds) else { return }
        
        UserDefaults.standard.set(data, forKey: Constants.preferencesIds)
        
        ProfileMediator.shared.update(preferencesIds: preferencesIds)
    }
}
