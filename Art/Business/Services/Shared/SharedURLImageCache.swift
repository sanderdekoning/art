//
//  SharedURLImageCache.swift
//  Art
//
//  Created by Sander de Koning on 07/05/2023.
//

import UIKit

enum SharedURLImageCache {
    static let defaultThumbnail = Cache<URLRequest, UIImage>(countLimit: 500)
}
