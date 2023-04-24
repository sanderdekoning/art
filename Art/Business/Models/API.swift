//
//  API.swift
//  Art
//
//  Created by Sander de Koning on 20/04/2023.
//

import Foundation

struct API {
    // For demonstration purposes hardcoding the API key and culture
    let key = Config.apiKey
    let culture = "en"
    
    var baseURL: URL {
        guard let url = URL(string: "https://www.rijksmuseum.nl/api/") else {
            // TODO: consider using optionals or handling unexpected API base url
            fatalError()
        }
        
        return url
    }
    
    var cultureURL: URL {
        guard let url = URL(string: "\(culture)/", relativeTo: baseURL) else {
            // TODO: consider using optionals handling unexpected API culture url
            fatalError()
        }
        
        return url
    }
    
    var collectionURL: URL {
        guard let url = URL(string: "collection", relativeTo: cultureURL) else {
            // TODO: consider using optionals handling unexpected API collection url
            fatalError()
        }
        
        return url
    }
    
    var authorizationURLQueryItem: URLQueryItem {
        URLQueryItem(name: "key", value: key)
    }
}
