//
//  CollectionWorkerError.swift
//  Art
//
//  Created by Sander de Koning on 20/04/2023.
//

import Foundation

enum CollectionWorkerError: LocalizedError, Equatable {
    case unexpectedStatusCode(Int)
    case unexpectedResponse(URL?)
}
