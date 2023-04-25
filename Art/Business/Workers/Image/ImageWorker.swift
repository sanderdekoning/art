//
//  ImageWorker.swift
//  Art
//
//  Created by Sander de Koning on 20/04/2023.
//

import UIKit

class ImageWorker {
    let session: URLSession
    let thumbnailCache: ImageRequestCacheProtocol
    let thumbnailSize: CGSize

    init(
        session: URLSession,
        thumbnailCache: any ImageRequestCacheProtocol,
        thumbnailSize: CGSize
    ) {
        self.session = session
        self.thumbnailCache = thumbnailCache
        self.thumbnailSize = thumbnailSize
    }
}

extension ImageWorker: ImageWorkerProtocol {
    func image(
        from url: URL,
        prefersThumbnail: Bool
    ) async throws -> UIImage {
        let request = request(for: url)

        // Check for a cached thumbnail
        if prefersThumbnail, let thumbnail = await cachedThumbnail(for: request) {
            return thumbnail
        }

        let (data, _) = try await session.data(for: request)
        let image = try image(from: data)
        let thumbnail = try await createAndCacheThumbnail(from: request, image: image)
        
        if prefersThumbnail, let thumbnail {
            return thumbnail
        }
        
        return image
    }
    
    func cachedThumbnail(from url: URL) async -> UIImage? {
        let request = request(for: url)
        return await thumbnailCache.cached(request: request)
    }
    
    func cachedThumbnail(for request: URLRequest) async -> UIImage? {
        await thumbnailCache.cached(request: request)
    }
    
    func clearCache() async {
        await thumbnailCache.removeAll()
    }
}

private extension ImageWorker {
    func request(for url: URL) -> URLRequest {
        URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
    }
    
    func createAndCacheThumbnail(from request: URLRequest, image: UIImage) async throws -> UIImage? {
        if let cached = await cachedThumbnail(for: request) {
            return cached
        }
        
        // TODO: consider whether failure to create a thumbnail needs specific requirements
        let thumbnail = await image.byPreparingThumbnail(ofSize: thumbnailSize)
        
        guard let thumbnail else {
            return nil
        }
        
        await thumbnailCache.set(image: thumbnail, for: request)
        return thumbnail
    }
    
    func image(from data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw ImageWorkerError.unexpectedData(data)
        }
        
        return image
    }
}
