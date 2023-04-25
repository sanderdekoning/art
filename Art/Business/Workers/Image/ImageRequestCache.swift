//
//  ImageRequestCache.swift
//  Art
//
//  Created by Sander de Koning on 21/04/2023.
//

import UIKit

class ImageRequestCache: ImageRequestCacheProtocol {
    private let cache = NSCache<AnyObject, UIImage>()
    
    init(countLimit: Int) {
        cache.countLimit = countLimit
    }
    
    func set(image: UIImage, for request: URLRequest) {
        cache.setObject(image, forKey: request as AnyObject)
    }
    
    func cached(request: URLRequest) -> UIImage? {
        cache.object(forKey: request as AnyObject)
    }
    
    func removeAll() {
        cache.removeAllObjects()
    }
}
