//
//  GetBookmarksGlossariesRequest.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 17.03.2025.
//

import Alamofire

// TODO: полное соответствие документу
struct GetBookmarksGlossariesRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String

    var url: String {
        "https://dermatology.awesum-apps.com" + "/api/dermatologic_term/bookmarks"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": "7LexM8IGOSmIrpEimANw",
            "_user_token": anonymousId
        ]
    }
}
