//
//  CollectionRequestsPending.swift
//  Art
//
//  Created by Sander de Koning on 23/04/2023.
//

import Foundation

actor CollectionRequestsPending: CollectionRequestsPendingProtocol {
    private var values = Set<CollectionRequest>()
    
    var hasPending: Bool {
        values.isEmpty == false
    }
    
    func isPending(request: CollectionRequest) -> Bool {
        values.contains(request)
    }
    
    func add(request: CollectionRequest) {
        values.insert(request)
    }
    
    func remove(request: CollectionRequest) {
        values.remove(request)
    }
    
    func removeAll() {
        values.removeAll()
    }
}
