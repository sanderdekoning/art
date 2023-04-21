//
//  NSCache.swift
//  Art
//
//  Created by Sander de Koning on 21/04/2023.
//

import UIKit

extension NSCache<AnyObject, UIImage> {
    static let artImageThumbnailCache = {
        let cache = NSCache<AnyObject, UIImage>()
        
        // TODO: evaluate thumbnail cache limits
        cache.countLimit = 100
        
        return cache
    }()
}
