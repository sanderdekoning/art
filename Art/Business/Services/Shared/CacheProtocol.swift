//
//  CacheProtocol.swift
//  Art
//
//  Created by Sander de Koning on 07/05/2023.
//

import Foundation

protocol CacheProtocol<Key, Value>: Actor {
    associatedtype Key
    associatedtype Value

    func set(value: Value, for key: Key)
    func cached(key: Key) -> Value?
    func removeAll()
}
