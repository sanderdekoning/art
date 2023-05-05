//
//  SharedImageWorker.swift
//  Art
//
//  Created by Sander de Koning on 25/04/2023.
//

import Foundation

class SharedImageWorker {
    static let defaultThumbnails = ImageWorker(
        session: .shared,
        // TODO: evaluate cache limits
        thumbnailCache: ImageRequestCache(countLimit: 500),
        // TODO: evaluate thumbnail size
        thumbnailSize: CGSize(width: 1200, height: 1200)
    )
}
