//
//  ArtObject.swift
//  Art
//
//  Created by Sander de Koning on 20/04/2023.
//

import Foundation

extension CollectionResponse {
    struct ArtObject: Decodable, Hashable {
        let links: Links
        let id: String
        let objectNumber: String
        let title: String
        let hasImage: Bool
        let principalOrFirstMaker: String
        let longTitle: String
        let showImage: Bool
        let permitDownload: Bool
        let webImage: Image
        let headerImage: Image?
        let productionPlaces: [String]
    }
}

extension CollectionResponse.ArtObject {
    struct Links: Decodable, Hashable {
        let api: URL
        let web: URL

        enum CodingKeys: String, CodingKey {
            case api = "self"
            case web
        }
    }

    struct Image: Decodable, Hashable {
        let guid: String?
        let offsetPercentageX: CGFloat
        let offsetPercentageY: CGFloat
        let width: CGFloat
        let height: CGFloat
        let url: URL
    }
}
