//
//  GetGlossaryDetailsRequest.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 17.03.2025.
//

import Alamofire

struct GetGlossaryDetailsRequest: APIRequestBody {
    let userToken: String
    let id: String
    
    var url: String {
        GlobalDefinitions.dermatologyDomain + "/api/dermatologic_term/details"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.dermatologyApiKey,
            "_user_token": userToken,
            "dermatologic_term_id": id
        ]
    }
}
