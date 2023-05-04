//
//  TaskStatusStore.swift
//  Art
//
//  Created by Sander de Koning on 29/04/2023.
//

import Foundation

actor TaskStatusStore<Identifier: Hashable, Value: Sendable>: TaskStatusStoreProtocol {
    private var statuses = [Identifier: TaskStatus<Value>]()

    func set(identifier: Identifier, status: TaskStatus<Value>) {
        statuses.updateValue(status, forKey: identifier)
    }

    func hasStatus(for identifier: Identifier) -> Bool {
        statuses.keys.contains(identifier)
    }

    func status(for identifier: Identifier) -> TaskStatus<Value>? {
        statuses[identifier]
    }

    var hasInProgress: Bool {
        statuses.values.contains { status in
            guard case .inProgress = status else {
                return false
            }

            return true
        }
    }

    var allFinished: [Value] {
        statuses.values.compactMap { status in
            if case .finished(let value) = status {
                return value
            }

            return nil
        }
    }

    func removeAll() {
        statuses.removeAll()
    }

    func removeStatus(for identifier: Identifier) {
        statuses.removeValue(forKey: identifier)
    }
}
