//
//  CollectionWorker.swift
//  Art
//
//  Created by Sander de Koning on 20/04/2023.
//

import Foundation

protocol CollectionWorkerProtocol {
    func collection(for collectionRequest: CollectionRequest) async throws -> CollectionResponse
}

struct CollectionWorker: CollectionWorkerProtocol {
    let session = URLSession.shared
    let decoder = JSONDecoder()
    
    func collection(for collectionRequest: CollectionRequest) async throws -> CollectionResponse {
        let (data, response) = try await session.data(for: collectionRequest.request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw CollectionWorkerError.unexpectedResponse(response)
        }
        
        guard httpResponse.statusCode == 200 else {
            throw CollectionWorkerError.unexpectedStatusCode(httpResponse.statusCode)
        }
        
        return try decoder.decode(CollectionResponse.self, from: data)
    }
}
