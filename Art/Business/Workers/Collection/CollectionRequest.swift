//
//  CollectionRequest.swift
//  Art
//
//  Created by Sander de Koning on 20/04/2023.
//

import Foundation

struct CollectionRequest: Hashable {
    let resultsPerPage: Int
    let page: Int

    private var urlQueryItems: [URLQueryItem] {
        [
            API().authorizationURLQueryItem,
            URLQueryItem(name: "s", value: "artist"),
            URLQueryItem(name: "imgonly", value: String(true)),
            URLQueryItem(name: "ps", value: String(resultsPerPage)),
            URLQueryItem(name: "p", value: String(page))
        ]
    }
    
    var url: URL {
        get throws {
            var url = API().collectionURL
            
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
