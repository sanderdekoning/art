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
            // TODO: handle missing API key error
            fatalError()
        }
        return key
    }()
}
