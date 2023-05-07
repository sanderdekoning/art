//
//  ImageWorker.swift
//  Art
//
//  Created by Sander de Koning on 20/04/2023.
//

import UIKit

struct ImageWorker {
    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }
}

extension ImageWorker: ImageWorkerProtocol {
    func image(from request: URLRequest) async throws -> UIImage {
        let (data, _) = try await session.data(for: request)
        let image = try image(from: data)
        return image
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
