//
//  CollectionWorkerProtocol.swift
//  Art
//
//  Created by Sander de Koning on 25/04/2023.
//

import Foundation

protocol CollectionWorkerProtocol {
    func collection(for request: CollectionRequest) async throws -> CollectionPageResponse
}
