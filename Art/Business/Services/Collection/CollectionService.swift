//
//  CollectionService.swift
//  Art
//
//  Created by Sander de Koning on 29/04/2023.
//

import Foundation

actor CollectionService: CollectionServiceProtocol {
    let statusStore: TaskStore
    private let worker: CollectionWorkerProtocol

    init(statusStore: TaskStore, worker: CollectionWorkerProtocol) {
        self.statusStore = statusStore
        self.worker = worker
    }

    func fetch(request: CollectionRequest) async throws -> CollectionPageResponse {
        if let taskStatus = await statusStore.status(for: request) {
            switch taskStatus {
            case .inProgress(let task):
                return try await task.value
            case .finished(let pageResponse):
                return pageResponse
            }
        }

        let task = Task {
            try await worker.collection(for: request)
        }

        await statusStore.set(request: request, status: .inProgress(task))

        do {
            let pageResponse = try await task.value

            await statusStore.set(request: request, status: .finished(pageResponse))

            return pageResponse
        } catch {
            await statusStore.removeStatus(for: request)

            throw error
        }
    }
}
