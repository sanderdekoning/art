//
//  ImageWorkerProtocol.swift
//  Art
//
//  Created by Sander de Koning on 25/04/2023.
//

import UIKit

protocol ImageWorkerProtocol {
    func image(
        from url: URL,
        prefersThumbnail: Bool
    ) async throws -> UIImage

    func cachedThumbnail(from url: URL) async -> UIImage?

    func clearCache() async
}
