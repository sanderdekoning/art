//
//  CollectionWorker.swift
//  Art
//
//  Created by Sander de Koning on 20/04/2023.
//

import Foundation

protocol CollectionWorkerProtocol {
    func collection(for request: CollectionRequest) async throws -> CollectionPageResponse
}

struct CollectionWorker: CollectionWorkerProtocol {
    let session: URLSession
    private let decoder = JSONDecoder()

    func collection(for request: CollectionRequest) async throws -> CollectionPageResponse {
        let (data, urlResponse) = try await session.data(for: request.request)
        
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            throw CollectionWorkerError.unexpectedResponse(urlResponse.url)
        }
        
        guard httpResponse.statusCode == 200 else {
            throw CollectionWorkerError.unexpectedStatusCode(httpResponse.statusCode)
        }
        
        let response = try decoder.decode(CollectionResponse.self, from: data)
        return CollectionPageResponse(page: request.page, response: response)
    }
}
