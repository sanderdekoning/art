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

    var baseURL: URL {
        Config.apiBaseURL
    }

    let language: Language

    var cultureURL: URL {
        guard let url = URL(string: "\(language.rawValue)/", relativeTo: baseURL) else {
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

extension API {
    enum Language: String {
        case english = "en"
        case dutch = "nl"
    }
}
