//
//  URLSession+Mocked.swift
//  ArtTests
//
//  Created by Sander de Koning on 24/04/2023.
//

import Foundation

extension URLSession {
    static var mocked: Self {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        
        return Self(configuration: config)
    }
}
