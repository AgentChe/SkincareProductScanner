//
//  DermatologyLoginRequest.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 18.03.2025.
//

import Alamofire

struct DermatologyLoginRequest: APIRequestBody {
    let userToken: String

    var url: String {
        GlobalDefinitions.dermatologyDomain + "/api/users/login"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.dermatologyApiKey,
            "user_token": userToken
        ]
    }
}
