//
//  CollectionResponseMock.swift
//  ArtTests
//
//  Created by Sander de Koning on 24/04/2023.
//

import Foundation
@testable import Art

// swiftlint:disable:next convenience_type
final class CollectionResponseMock {
    private static var collectionURL: URL {
        Bundle(for: self).url(
            forResource: "CollectionResponse",
            withExtension: ".json"
        )!
    }

    static var collection: Data {
        get throws {
            try .init(contentsOf: collectionURL)
        }
    }

    static var response: CollectionResponse {
        get throws {
            try JSONDecoder().decode(CollectionResponse.self, from: collection)
        }
    }
}
