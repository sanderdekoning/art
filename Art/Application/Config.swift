//
//  Config.swift
//  Art
//
//  Created by Sander de Koning on 24/04/2023.
//

import Foundation

enum Config {
    private enum Keys: String {
        case apiKey = "API_KEY"
        case apiBaseURL = "API_BASE_URL"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let infoDictionary = Bundle.main.infoDictionary else {
            // TODO: handle configuration loading error
            fatalError()
        }
        
        return infoDictionary
    }()
}

extension Config {
    static let apiKey: String = {
        guard let key = Config.infoDictionary[Keys.apiKey.rawValue] as? String else {
            // TODO: handle missing API key
            fatalError()
        }
        return key
    }()
    
    static let apiBaseURL: URL = {
        guard let urlString = Config.infoDictionary[Keys.apiBaseURL.rawValue] as? String else {
            // TODO: handle missing API base URL string
            fatalError()
        }
        guard let url = URL(string: urlString) else {
            // TODO: handle API base URL string error
            fatalError()
        }
        
        return url
    }()
}
