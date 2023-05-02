//
//  CollectionWorkerMock.swift
//  ArtTests
//
//  Created by Sander de Koning on 02/05/2023.
//

import Foundation
@testable import Art

@MainActor
final class CollectionWorkerMock: CollectionWorkerProtocol {
    var collectionStub: ((CollectionRequest) async throws -> CollectionPageResponse)?

    func collection(for request: CollectionRequest) async throws -> CollectionPageResponse {
        guard let collectionStub else {
            throw StubError.missingStub
        }

        return try await collectionStub(request)
    }
}
