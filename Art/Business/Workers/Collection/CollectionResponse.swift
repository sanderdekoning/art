//
//  CollectionResponse.swift
//  Art
//
//  Created by Sander de Koning on 20/04/2023.
//

import Foundation

struct CollectionResponse: Decodable, Hashable {
    let elapsedMilliseconds: Int
    let count: Int
    let artObjects: [ArtObject]
}

/// CollectionPageResponse is a CollectionResponse with its page request reference. As the API does not provide this in the response
/// it can be useful for pagination
struct CollectionPageResponse: Decodable, Hashable {
    let page: Int
    let response: CollectionResponse
}
