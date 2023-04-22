//
//  CollectionPageResponse.swift
//  Art
//
//  Created by Sander de Koning on 22/04/2023.
//

import Foundation

protocol CollectionPageResponseProtocol: Actor {
    func set(page: Int, response: CollectionResponse?)
    func remove(page: Int)
    func removeAll()
    func contains(page: Int) -> Bool
    
    var responses: [Int: CollectionResponse?] { get }
}

actor CollectionPageResponse: CollectionPageResponseProtocol {
    private var values = [Int: CollectionResponse?]()
    
    func set(page: Int, response: CollectionResponse?) {
        values.updateValue(response, forKey: page)
    }
    
    func remove(page: Int) {
        values.removeValue(forKey: page)
    }
    
    func removeAll() {
        values.removeAll()
    }
    
    func contains(page: Int) -> Bool {
        values.keys.contains(page)
    }
    
    var responses: [Int: CollectionResponse?] {
        values
    }
}
