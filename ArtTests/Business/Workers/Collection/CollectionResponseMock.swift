//
//  CollectionResponseMock.swift
//  ArtTests
//
//  Created by Sander de Koning on 24/04/2023.
//

import Foundation

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
}
