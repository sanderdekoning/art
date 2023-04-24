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
            API(culture: .en).authorizationURLQueryItem,
            URLQueryItem(name: "s", value: "artist"),
            URLQueryItem(name: "imgonly", value: String(true)),
            URLQueryItem(name: "ps", value: String(resultsPerPage)),
            URLQueryItem(name: "p", value: String(page))
        ]
    }
    
    var url: URL {
        get throws {
            var url = API(culture: .en).collectionURL

            guard #available(iOS 16.0, *) else {
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                components?.queryItems = urlQueryItems
                
                guard let url = components?.url else {
                    throw URLError(.badURL)
                }

                return url
            }
            
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
