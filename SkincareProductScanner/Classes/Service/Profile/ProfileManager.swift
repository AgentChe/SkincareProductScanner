//
//  ProfileManager.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 06.09.2024.
//

import RxSwift
import RxCocoa

// TODO
protocol ProfileManagerProtocol: AnyObject {
    func create() -> Single<Void>
    func binding() -> Single<Void>
    func setup(profile: Profile) -> Single<RequestResult>
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
    
    func setup(profile: Profile) -> Single<RequestResult> {
        let request = SetProfileRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { [weak self] result in
                guard result.success else { return }
                
                self?.store(profile: profile, notify: true)
            })
    }
    
    func obtainProfile(forceUpdate: Bool) -> Single<Profile?> {
        forceUpdate ? loadProfile() : cachedProfile().map { profile -> Profile? in profile }
    }
}

// MARK: Private
private extension ProfileManager {
    enum Constants {
        static let skinType = "pm_skin_type"
    }
    
    func store(profile: Profile, notify: Bool) {
//        let nameData: Data? = {
//            guard let name = profile.name else { return nil }
//            return try? JSONEncoder().encode(name)
//        }()
//        let avatarData: Data? = {
//            guard let avatar = profile.avatar else { return nil }
//            return try? JSONEncoder().encode(avatar)
//        }()
//        let sizeData: Data? = {
//            guard let size = profile.size else { return nil }
//            return try? JSONEncoder().encode(size)
//        }()
//        let genderData: Data? = {
//            guard let gender = profile.gender else { return nil }
//            return try? JSONEncoder().encode(gender)
//        }()
//        let heightData: Data? = {
//            guard let height = profile.height else { return nil }
//            return try? JSONEncoder().encode(height)
//        }()
//        let interestedColorsData: Data? = {
//            guard let interestedColors = profile.interestedColors else { return nil }
//            return try? JSONEncoder().encode(interestedColors)
//        }()
//        let occasionsData: Data? = {
//            guard let occasions = profile.occasions else { return nil }
//            return try? JSONEncoder().encode(occasions)
//        }()
//        let seasonData: Data? = {
//            guard let season = profile.season else { return nil }
//            return try? JSONEncoder().encode(season)
//        }()
//        
//        UserDefaults.standard.set(nameData, forKey: Constants.nameKey)
//        UserDefaults.standard.set(avatarData, forKey: Constants.avatarKey)
//        UserDefaults.standard.set(sizeData, forKey: Constants.sizeKey)
//        UserDefaults.standard.set(genderData, forKey: Constants.genderKey)
//        UserDefaults.standard.set(heightData, forKey: Constants.heightKey)
//        UserDefaults.standard.set(interestedColorsData, forKey: Constants.interestedColorsKey)
//        UserDefaults.standard.set(occasionsData, forKey: Constants.occasionsKey)
//        UserDefaults.standard.set(seasonData, forKey: Constants.seasonKey)
//        
//        ProfileMediator.shared.update(profile: profile)
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
//            let name: String? = {
//                guard let data = UserDefaults.standard.data(forKey: Constants.nameKey) else { return nil }
//                return try? JSONDecoder().decode(String.self, from: data)
//            }()
//            
//            let avatar: URL? = {
//                guard let data = UserDefaults.standard.data(forKey: Constants.avatarKey) else { return nil }
//                return try? JSONDecoder().decode(URL.self, from: data)
//            }()
//            
//            let size: Size? = {
//                guard let data = UserDefaults.standard.data(forKey: Constants.sizeKey) else { return nil }
//                return try? JSONDecoder().decode(Size.self, from: data)
//            }()
//            
//            let gender: Gender? = {
//                guard let data = UserDefaults.standard.data(forKey: Constants.genderKey) else { return nil }
//                return try? JSONDecoder().decode(Gender.self, from: data)
//            }()
//            
//            let height: Height? = {
//                guard let data = UserDefaults.standard.data(forKey: Constants.heightKey) else { return nil }
//                return try? JSONDecoder().decode(Height.self, from: data)
//            }()
//            
//            let interestedColors: [String]? = {
//                guard let data = UserDefaults.standard.data(forKey: Constants.interestedColorsKey) else { return nil }
//                return try? JSONDecoder().decode([String].self, from: data)
//            }()
//            
//            let occasions: [Occasion]? = {
//                guard let data = UserDefaults.standard.data(forKey: Constants.occasionsKey) else { return nil }
//                return try? JSONDecoder().decode([Occasion].self, from: data)
//            }()
//            
//            let season: Season? = {
//                guard let data = UserDefaults.standard.data(forKey: Constants.seasonKey) else { return nil }
//                return try? JSONDecoder().decode(Season.self, from: data)
//            }()
            
            let profile = Profile()
            
            single(.success(profile))
            
            return Disposables.create()
        }
    }
}
