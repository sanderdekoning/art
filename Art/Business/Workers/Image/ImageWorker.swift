//
//  ImageWorker.swift
//  Art
//
//  Created by Sander de Koning on 20/04/2023.
//

import UIKit

protocol ImageWorkerProtocol {
    func image(
        from url: URL,
        thumbnailSize: CGSize,
        prefersThumbnail: Bool
    ) async throws -> UIImage
}

class ImageWorker: ImageWorkerProtocol {
    let session: URLSession
    let thumbnailCache: ImageRequestCacheProtocol

    init(
        session: URLSession,
        thumbnailCache: any ImageRequestCacheProtocol
    ) {
        self.session = session
        self.thumbnailCache = thumbnailCache
    }
    
    func image(
        from url: URL,
        thumbnailSize: CGSize,
        prefersThumbnail: Bool
    ) async throws -> UIImage {
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)

        // Check for a cached thumbnail
        if prefersThumbnail, let thumbnail = thumbnailCache.cached(request: request) {
            return thumbnail
        }

        let (data, _) = try await session.data(for: request)

        // Check again for a cached thumbnail after awaiting request
        if prefersThumbnail, let thumbnail = thumbnailCache.cached(request: request) {
            return thumbnail
        }
        
        return try await cacheThumbnail(
            from: request,
            data: data,
            thumbnailSize: thumbnailSize,
            prefersThumbnail: prefersThumbnail
        )
    }
}

extension ImageWorker {
    static var sharedThumbnail: ImageWorker {
        ImageWorker(session: .shared, thumbnailCache: ImageRequestCache.sharedThumbnail)
    }
}

private extension ImageWorker {
    func cacheThumbnail(
        from request: URLRequest,
        data: Data,
        thumbnailSize: CGSize,
        prefersThumbnail: Bool
    ) async throws -> UIImage {
        let image = try image(from: data)
        
        // Explicitly check cancellation before preparing thumbnail
        try Task.checkCancellation()
        
        // TODO: consider whether failure to create a thumbnail needs specific requirements
        let thumbnail = await image.byPreparingThumbnail(ofSize: thumbnailSize)
        
        if let thumbnail {
            thumbnailCache.set(image: thumbnail, for: request)
        }
        
        guard prefersThumbnail else {
            return image
        }
        
        return thumbnail ?? image
    }
}

private extension ImageWorker {
    func image(from data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw ImageWorkerError.unexpectedData(data)
        }
        
        return image
    }
}
