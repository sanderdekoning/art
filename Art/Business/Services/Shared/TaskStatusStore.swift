//
//  TaskStatusStore.swift
//  Art
//
//  Created by Sander de Koning on 29/04/2023.
//

import Foundation

actor TaskStatusStore<Request: Hashable, Response: Sendable> {
    private var statuses = [Request: TaskStatus<Response>]()

    func set(request: Request, status: TaskStatus<Response>) {
        statuses.updateValue(status, forKey: request)
    }

    func didRequest(request: Request) -> Bool {
        statuses.keys.contains(request)
    }

    func status(for request: Request) -> TaskStatus<Response>? {
        statuses[request]
    }

    var hasInProgress: Bool {
        statuses.values.contains { responseStatus in
            guard case .inProgress = responseStatus else {
                return false
            }

            return true
        }
    }

    var responses: [Response] {
        statuses.values.compactMap { value in
            if case .finished(let pageResponse) = value {
                return pageResponse
            }

            return nil
        }
    }

    func removeAll() {
        statuses.removeAll()
    }

    func removeStatus(for request: Request) {
        statuses.removeValue(forKey: request)
    }
}
