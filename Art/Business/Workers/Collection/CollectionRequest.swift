//
//  CollectionRequest.swift
//  Art
//
//  Created by Sander de Koning on 20/04/2023.
//

import Foundation

struct CollectionRequest {
    let api = API()
    let involvedMaker: String

    private var urlQueryItems: [URLQueryItem] {
        [
            api.authorizationURLQueryItem,
            URLQueryItem(name: "involvedMaker", value: involvedMaker)
        ]
    }
    
    var url: URL {
        get throws {
            var url = api.collectionURL
            
            url.append(queryItems: urlQueryItems)
            
            return url
        }
    }
    
    var request: URLRequest {
        get throws {
            var request = try URLRequest(url: url)
            request.httpMethod = "GET"
            return request
        }
    }
}
