//
//  Collection.swift
//  Art
//
//  Created by Sander de Koning on 20/04/2023.
//

import Foundation

// Defining as an alias of the response object; in reality this will likely have its own schema
typealias Art = CollectionResponse.ArtObject

// FIXME: there is a theoretical chance of identical page + art hashables from the API
// The API can return identical art objects when sorted by maker
struct ArtPage: Hashable {
    let art: Art
    let page: Int
}
