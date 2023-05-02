//
//  CollectionServiceTests.swift
//  ArtTests
//
//  Created by Sander de Koning on 01/05/2023.
//

import XCTest
@testable import Art

@MainActor
final class CollectionServiceTests: XCTestCase {
    var sut: CollectionService!
    var statusStore: TaskStatusStore<CollectionRequest, CollectionPageResponse>!
    var worker: CollectionWorkerMock!

    override func setUpWithError() throws {
        executionTimeAllowance = 5

        statusStore = TaskStatusStore<CollectionRequest, CollectionPageResponse>()
        worker = CollectionWorkerMock()
        sut = CollectionService(statusStore: statusStore, worker: worker)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testFetch_storeStatusNil_shouldFetchFromWorker() async throws {
        let request = CollectionRequest(resultsPerPage: 50, page: 1)
        let response = try CollectionPageResponse(
            page: 1,
            response: CollectionResponseMock.response
        )

        let expectation = XCTestExpectation(description: "Fetched from worker")
        expectation.assertForOverFulfill = true

        worker.collectionStub = { _ in
            expectation.fulfill()
            return response
        }

        _ = try await sut.fetch(request: request)
        await fulfillment(of: [expectation])
    }

    func testFetch_storeStatusNil_shouldSetStatusInProgressInStore() async throws {
        let request = CollectionRequest(resultsPerPage: 50, page: 1)
        let response = try CollectionPageResponse(
            page: 1,
            response: CollectionResponseMock.response
        )

        let expectation = XCTestExpectation(description: "Task status equals in progress")
        expectation.assertForOverFulfill = true

        worker.collectionStub = { [unowned self] _ in
            let status = await sut.statusStore.status(for: request)

            if case .inProgress = status {
                expectation.fulfill()
            }

            return response
        }

        _ = try await sut.fetch(request: request)

        await fulfillment(of: [expectation])
    }

    func testFetch_storeStatusInProgress_shouldNotFetchFromWorker() async throws {
        let request = CollectionRequest(resultsPerPage: 50, page: 1)
        let task = Task<CollectionPageResponse, Error> {
            try CollectionPageResponse(
                page: 1,
                response: CollectionResponseMock.response
            )
        }
        await sut.statusStore.set(request: request, status: .inProgress(task))

        worker.collectionStub = nil
        _ = try await sut.fetch(request: request)
    }

    func testFetch_storeStatusNil_shouldSetStatusFinishedInStore() async throws {
        let request = CollectionRequest(resultsPerPage: 50, page: 1)
        let response = try CollectionPageResponse(
            page: 1,
            response: CollectionResponseMock.response
        )

        worker.collectionStub = { _ in
            response
        }
        _ = try await sut.fetch(request: request)

        let status = await sut.statusStore.status(for: request)

        let expectation = XCTestExpectation(description: "Task status equals finished")
        if case .finished = status {
            expectation.fulfill()
        }

        await fulfillment(of: [expectation])
    }

    func testFetch_storeStatusFinished_shouldNotFetchFromWorker() async throws {
        let request = CollectionRequest(resultsPerPage: 50, page: 1)
        let response = try CollectionPageResponse(
            page: 1,
            response: CollectionResponseMock.response
        )

        await sut.statusStore.set(request: request, status: .finished(response))
        worker.collectionStub = nil
        _ = try await sut.fetch(request: request)
    }

    func testFetch_storeStatusNil_fetchError_shouldThrowError() async throws {
        let request = CollectionRequest(resultsPerPage: 50, page: 1)

        worker.collectionStub = { _ in
            throw StubError.anyError
        }

        let task = Task<CollectionPageResponse, Error> {
            try await sut.fetch(request: request)
        }
        let result = await task.result

        XCTAssertThrowsError(try result.get()) { error in
            XCTAssertEqual(error as? StubError, StubError.anyError)
        }
    }

    func testFetch_storeStatusInProgress_fetchError_shouldRemoveStoreStatus() async throws {
        let request = CollectionRequest(resultsPerPage: 50, page: 1)

        worker.collectionStub = { _ in
            throw StubError.anyError
        }

        _ = try? await sut.fetch(request: request)

        let status = await sut.statusStore.status(for: request)
        XCTAssertNil(status)
    }
}
