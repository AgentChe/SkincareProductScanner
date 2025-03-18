//
//  GetGlossariesRequest.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 17.03.2025.
//

import Alamofire

struct GetGlossariesRequest: APIRequestBody {
    let userToken: String
    
    var url: String {
        GlobalDefinitions.dermatologyDomain + "/api/dermatologic_term"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.dermatologyApiKey,
            "_user_token": userToken
        ]
    }
}
