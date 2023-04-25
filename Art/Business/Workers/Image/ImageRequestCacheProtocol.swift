//
//  ImageRequestCacheProtocol.swift
//  Art
//
//  Created by Sander de Koning on 25/04/2023.
//

import UIKit

protocol ImageRequestCacheProtocol {
    func set(image: UIImage, for request: URLRequest)
    func cached(request: URLRequest) -> UIImage?
    func removeAll()
}
