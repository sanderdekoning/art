//
//  ImageService.swift
//  Art
//
//  Created by Sander de Koning on 07/05/2023.
//

import UIKit

actor ImageService<C: CacheProtocol<URLRequest, UIImage>>: ImageServiceProtocol {
    private let worker: ImageWorkerProtocol
    private let thumbnailCache: C
    private let thumbnailSize: CGSize

    init(
        worker: some ImageWorkerProtocol,
        thumbnailCache: C,
        thumbnailSize: CGSize
    ) {
        self.worker = worker
        self.thumbnailCache = thumbnailCache
        self.thumbnailSize = thumbnailSize
    }
}

extension ImageService {
    func cachedThumbnail(for url: URL) async -> UIImage? {
        let request = request(for: url)
        return await thumbnailCache.cached(key: request)
    }

    func image(from url: URL, prefersThumbnail: Bool) async throws -> UIImage {
        let request = request(for: url)

        // Check for a cached thumbnail
        if prefersThumbnail, let thumbnail = await thumbnailCache.cached(key: request) {
            return thumbnail
        }

        let image = try await worker.image(from: request)
        let thumbnail = try await createAndCacheThumbnail(from: request, image: image)

        if prefersThumbnail, let thumbnail {
            return thumbnail
        }

        return image
    }
}

private extension ImageService {
    func createAndCacheThumbnail(
        from request: URLRequest,
        image: UIImage
    ) async throws -> UIImage? {
        if let cached = await thumbnailCache.cached(key: request) {
            return cached
        }

        // TODO: consider whether failure to create a thumbnail needs specific requirements
        let thumbnail = await image.byPreparingThumbnail(ofSize: thumbnailSize)

        guard let thumbnail else {
            return nil
        }

        await thumbnailCache.set(value: thumbnail, for: request)
        return thumbnail
    }

    func request(for url: URL) -> URLRequest {
        URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
    }
}
