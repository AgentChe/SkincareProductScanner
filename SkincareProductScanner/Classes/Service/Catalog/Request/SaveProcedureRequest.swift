//
//  SaveProcedureRequest.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 17.03.2025.
//

import Alamofire

struct SaveProcedureRequest: APIRequestBody {
    let userToken: String
    let id: String

    var url: String {
        GlobalDefinitions.dermatologyDomain + "/api/procedure/save"
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
