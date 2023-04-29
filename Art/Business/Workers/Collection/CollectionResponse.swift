//
//  CollectionResponse.swift
//  Art
//
//  Created by Sander de Koning on 20/04/2023.
//

import Foundation

struct CollectionResponse: Decodable {
    let elapsedMilliseconds: Int
    let count: Int
    let artObjects: [ArtObject]
}
