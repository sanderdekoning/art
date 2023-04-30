//
//  CollectionPageResponse.swift
//  Art
//
//  Created by Sander de Koning on 29/04/2023.
//

import Foundation

/// CollectionPageResponse is a CollectionResponse with its page request reference. As the API does not
/// provide this in the response it can be useful for pagination
struct CollectionPageResponse: Decodable {
    let page: Int
    let response: CollectionResponse
}
