//
//  CollectionPageResponseStore.swift
//  Art
//
//  Created by Sander de Koning on 23/04/2023.
//

import Foundation

actor CollectionPageResponseStore: CollectionPageResponseStoreProtocol {
    private var values = Set<CollectionPageResponse>()
    
    var responses: Set<CollectionPageResponse> {
        values
    }
    
    func store(response: CollectionPageResponse) {
        values.insert(response)
    }
    
    func removeAll() {
        values.removeAll()
    }
    
    func hasResponse(forPage page: Int) -> Bool {
        values.contains { $0.page == page }
    }
    
    var maxPageResponse: Int? {
        values.map { $0.page }.max()
    }
    
    var maxResponseTotalCount: Int? {
        // Get the largest total count from all the responses
        values.map { $0.response.count }.max()
    }
}
