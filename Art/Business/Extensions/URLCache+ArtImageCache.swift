//
//  URLCache+ArtImageCache.swift
//  Art
//
//  Created by Sander de Koning on 21/04/2023.
//

import Foundation

extension URLCache {
    // TODO: evaluate cache sizes and downsizing/downsampling
    static let artImageCache = URLCache(memoryCapacity: 100, diskCapacity: 200)
}
