//
//  ImageWorker+SharedDefault.swift
//  Art
//
//  Created by Sander de Koning on 25/04/2023.
//

import Foundation

extension ImageWorker {
    static var sharedDefaultThumbnail: ImageWorker {
        ImageWorker(
            session: .shared,
            // TODO: evaluate cache limits
            thumbnailCache: ImageRequestCache(countLimit: 500),
            // TODO: evaluate thumbnail size
            thumbnailSize: CGSize(width: 1200, height: 1200)
        )
    }
}
