//
//  ImageServiceProtocol.swift
//  Art
//
//  Created by Sander de Koning on 07/05/2023.
//

import UIKit

protocol ImageServiceProtocol {
    func cachedThumbnail(for url: URL) async -> UIImage?

    func image(from url: URL, prefersThumbnail: Bool) async throws -> UIImage
}
