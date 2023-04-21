//
//  CollectionPageResponse.swift
//  Art
//
//  Created by Sander de Koning on 22/04/2023.
//

import Foundation

actor CollectionPageResponse {
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
