//
//  ImageWorkerProtocol.swift
//  Art
//
//  Created by Sander de Koning on 25/04/2023.
//

import UIKit

protocol ImageWorkerProtocol: Sendable {
    func image(from request: URLRequest) async throws -> UIImage
}
