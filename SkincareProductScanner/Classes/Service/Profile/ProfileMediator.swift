//
//  ProfileMediator.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 25.01.2025.
//

import RxSwift
import RxCocoa

final class ProfileMediator {
    static let shared = ProfileMediator()
    
    private init() {}
    
    private lazy var didUpdateProfileTrigger = PublishRelay<Profile>()
    private lazy var didUpdateSkinTypesIdsTrigger = PublishRelay<[String]>()
    private lazy var didUpdateGoalsIdsTrigger = PublishRelay<[String]>()
    private lazy var didUpdatePreferencesIdsTrigger = PublishRelay<[String]>()
}

// MARK: Public
extension ProfileMediator {
    func update(profile: Profile) {
        didUpdateProfileTrigger.accept(profile)
    }
    
    func update(skinTypesIds: [String]) {
        didUpdateSkinTypesIdsTrigger.accept(skinTypesIds)
    }
    
    func update(goalsIds: [String]) {
        didUpdateGoalsIdsTrigger.accept(goalsIds)
    }
    
    func update(preferencesIds: [String]) {
        didUpdatePreferencesIdsTrigger.accept(preferencesIds)
    }
    
    var didUpdateProfile: Signal<Profile> {
        didUpdateProfileTrigger.asSignal()
    }
    
    var didUpdateSkinTypesIds: Signal<[String]> {
        didUpdateSkinTypesIdsTrigger.asSignal()
    }
    
    var didUpdateGoalsIds: Signal<[String]> {
        didUpdateGoalsIdsTrigger.asSignal()
    }
    
    var didUpdatePreferencesIds: Signal<[String]> {
        didUpdatePreferencesIdsTrigger.asSignal()
    }
}
