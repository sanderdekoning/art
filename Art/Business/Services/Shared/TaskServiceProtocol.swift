//
//  TaskServiceProtocol.swift
//  Art
//
//  Created by Sander de Koning on 29/04/2023.
//

import Foundation

protocol TaskServiceProtocol<Identifier, Value> {
    associatedtype Identifier: Hashable
    associatedtype Value: Sendable

    var statusStore: any TaskStatusStoreProtocol<Identifier, Value> { get }

    func fetch(request: Identifier) async throws -> Value
}
