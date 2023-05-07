//
//  ArtPage.swift
//  Art
//
//  Created by Sander de Koning on 08/05/2023.
//

import Foundation

// FIXME: there is a theoretical chance of identical page + art hashables from the API
// The API can return identical art objects when sorted by maker
struct ArtPage: Hashable {
    let art: Art
    let page: Int
}
