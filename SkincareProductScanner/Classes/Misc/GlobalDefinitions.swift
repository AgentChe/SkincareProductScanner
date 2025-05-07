//
//  GlobalDefinitions.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

final class GlobalDefinitions {
    static let domain = "https://skincarescanner.korrekted.com"
    static let apiKey = "1E0fCaZs7zvSEZoXPP"
    
    static let dermatologyDomain = "https://dermatology.awesum-apps.com"
    static let dermatologyApiKey = "7LexM8IGOSmIrpEimANw"
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "kVEafkhPlIzMsuT6"
    
    static let applicationTag = "SKIN_CARE_PRODUCT_SCANNER"
    static let amplitudeApiKey = "17fa94a421fa4349d8b1db59c8e06fbe"
    
    static let termsOfServiceUrl = URL(string: "https://sergeyapps.com/terms-of-use")!
    static let privacyPolicyUrl = URL(string: "https://sergeyapps.com/privacy-policy")!
    static let contactUsUrl = URL(string: "https://sergeyapps.com/#contact")!
    
    enum Paygate {
        static let yearly = "sj.skincareproductscanner.yearly"
        static let weekly = "sj.skincareproductscanner.weekly"
    }
    
    enum References {
        static let link1 = URL(string: "https://www.nlm.nih.gov")!
        static let link2 = URL(string: "https://www.cir-safety.org")!
    }
}
