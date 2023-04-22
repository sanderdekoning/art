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
    let artImageCache: URLCache
    let artImageThumbnailCache: NSCache<AnyObject, UIImage>

    init(
        session: URLSession,
        artImageCache: URLCache,
        artImageThumbnailCache: NSCache<AnyObject, UIImage>
    ) {
        self.session = session
        self.artImageCache = artImageCache
        self.artImageThumbnailCache = artImageThumbnailCache
    }
    
    private func request(for url: URL) -> URLRequest {
        // TODO: consider server cache-control
        URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
    }
    
    func image(
        from url: URL,
        thumbnailSize: CGSize,
        prefersThumbnail: Bool
    ) async throws -> UIImage {
        let request = request(for: url)

        if let cachedImage = try cachedImage(for: request, prefersThumbnail: prefersThumbnail) {
            return cachedImage
        }

        let (data, response) = try await session.data(for: request)

        return try await cacheImageAndThumbnail(
            from: request,
            response: response,
            data: data,
            thumbnailSize: thumbnailSize,
            prefersThumbnail: prefersThumbnail
        )
    }
}

private extension ImageWorker {
    func cachedImage(for request: URLRequest, prefersThumbnail: Bool) throws -> UIImage? {
        if prefersThumbnail, let thumbnail = artImageThumbnailCache.object(
            forKey: request as AnyObject
        ) {
            return thumbnail
        }
        
        guard let cachedResponse = artImageCache.cachedResponse(for: request) else {
            return nil
        }
        
        return try image(from: cachedResponse.data)
    }
    
    func cacheImageAndThumbnail(
        from request: URLRequest,
        response: URLResponse,
        data: Data,
        thumbnailSize: CGSize,
        prefersThumbnail: Bool
    ) async throws -> UIImage {
        let image = try image(from: data)
        
        // TODO: consider whether we want to always cache before the thumbnail
        let cached = CachedURLResponse(response: response, data: data)
        artImageCache.storeCachedResponse(cached, for: request)
        
        // Explicitly check cancellation before preparing thumbnail
        try Task.checkCancellation()
        
        // TODO: consider whether failure to create a thumbnail needs specific requirements
        let thumbnail = await image.byPreparingThumbnail(ofSize: thumbnailSize)
        
        if let thumbnail {
            artImageThumbnailCache.setObject(thumbnail, forKey: request as AnyObject)
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
