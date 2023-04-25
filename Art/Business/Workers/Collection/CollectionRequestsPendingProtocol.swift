//
//  CollectionRequestsPendingProtocol.swift
//  Art
//
//  Created by Sander de Koning on 25/04/2023.
//

import Foundation

protocol CollectionRequestsPendingProtocol: Actor {
    var hasPending: Bool { get }
    
    func isPending(request: CollectionRequest) -> Bool
    func add(request: CollectionRequest)
    func remove(request: CollectionRequest)
    func removeAll()
}
