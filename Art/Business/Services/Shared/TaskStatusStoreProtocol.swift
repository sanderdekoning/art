//
//  TaskStatusStoreProtocol.swift
//  Art
//
//  Created by Sander de Koning on 29/04/2023.
//

import Foundation

protocol TaskStatusStoreProtocol<Identifier, Value>: Actor {
    associatedtype Identifier: Hashable
    associatedtype Value: Sendable

    var hasInProgress: Bool { get }
    var allFinished: [Value] { get }

    func set(identifier: Identifier, status: TaskStatus<Value>)
    func hasStatus(for identifier: Identifier) -> Bool
    func status(for identifier: Identifier) -> TaskStatus<Value>?

    func removeAll()
    func removeStatus(for identifier: Identifier)
}
