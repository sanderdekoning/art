//
//  Cache.swift
//  Art
//
//  Created by Sander de Koning on 07/05/2023.
//

import Foundation

actor Cache<Key, Value: AnyObject>: CacheProtocol {
    private let cache = NSCache<AnyObject, Value>()

    init(countLimit: Int) {
        cache.countLimit = countLimit
    }

    func set(value: Value, for key: Key) {
        cache.setObject(value, forKey: key as AnyObject)
    }

    func cached(key: Key) -> Value? {
        cache.object(forKey: key as AnyObject)
    }

    func removeAll() {
        cache.removeAllObjects()
    }
}
