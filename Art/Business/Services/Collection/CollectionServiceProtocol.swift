//
//  CollectionServiceProtocol.swift
//  Art
//
//  Created by Sander de Koning on 29/04/2023.
//

import Foundation

protocol CollectionServiceProtocol {
    typealias TaskStore = TaskStatusStore<CollectionRequest, CollectionPageResponse>

    var statusStore: TaskStore { get }
    
    func fetch(request: CollectionRequest) async throws -> CollectionPageResponse
}
