//
//  SharedCache.swift
//  Art
//
//  Created by Sander de Koning on 07/05/2023.
//

import UIKit

enum SharedCache {
    static let defaultURLRequestThumbnail = Cache<URLRequest, UIImage>(countLimit: 500)
}
