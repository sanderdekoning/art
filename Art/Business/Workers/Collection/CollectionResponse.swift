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

struct CollectionPageResponse: Decodable, Hashable {
    let page: Int
    let response: CollectionResponse
}
