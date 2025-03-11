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
}

// MARK: Public
extension ProfileMediator {
    func update(profile: Profile) {
        didUpdateProfileTrigger.accept(profile)
    }
    
    var didUpdateProfile: Signal<Profile> {
        didUpdateProfileTrigger.asSignal()
    }
}
