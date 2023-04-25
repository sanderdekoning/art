//
//  CollectionPageResponseStoreProtocol.swift
//  Art
//
//  Created by Sander de Koning on 25/04/2023.
//

import Foundation

protocol CollectionPageResponseStoreProtocol: Actor {
    var responses: Set<CollectionPageResponse> { get }
    func store(response: CollectionPageResponse)
    func removeAll()
    func hasResponse(forPage page: Int) -> Bool
    
    var maxPageResponse: Int? { get }
    var maxResponseTotalCount: Int? { get }
}
