//
//  GetProcedureDetailsRequest.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 17.03.2025.
//

import Alamofire

struct GetProcedureDetailsRequest: APIRequestBody {
    let userToken: String
    let id: String
    
    var url: String {
        GlobalDefinitions.dermatologyDomain + "/api/procedure/details"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.dermatologyApiKey,
            "_user_token": userToken,
            "procedure_id": id
        ]
    }
}
