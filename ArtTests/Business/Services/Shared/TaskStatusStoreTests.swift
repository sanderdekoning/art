//
//  TaskStatusStoreTests.swift
//  ArtTests
//
//  Created by Sander de Koning on 01/05/2023.
//

import XCTest
@testable import Art

final class TaskStatusStoreTests: XCTestCase {
    var sut: TaskStatusStore<CollectionRequest, CollectionResponse>!
    let request = CollectionRequest(resultsPerPage: 50, page: 1)

    override func setUpWithError() throws {
        executionTimeAllowance = 5

        sut = TaskStatusStore()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testHasStatus_withNoStatuses_shouldReturnFalse() async throws {
        let didRequest = await sut.hasStatus(for: request)
        XCTAssertFalse(didRequest)
    }

    func testHasStatus_withInProgressStatus_shouldReturnTrue() async throws {
        let task = Task<CollectionResponse, Error> {
            try CollectionResponseMock.response
        }
        await sut.set(identifier: request, status: .inProgress(task))
        let didRequest = await sut.hasStatus(for: request)
        XCTAssertTrue(didRequest)
    }

    func testStatusForIdentifier_statusInProgress_shouldReturnInProgress() async throws {
        let task = Task<CollectionResponse, Error> {
            return try CollectionResponseMock.response
        }
        await sut.set(identifier: request, status: .inProgress(task))
        let status = await sut.status(for: request)
        let expectation = XCTestExpectation(description: "Task status equals in progress")
        if case .inProgress = status {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation])
    }

    func testStatusForIdentifier_statusFinished_shouldReturnFinished() async throws {
        let response = try CollectionResponseMock.response
        await sut.set(identifier: request, status: .finished(response))
        let status = await sut.status(for: request)
        let expectation = XCTestExpectation(description: "Task status equals finished")
        if case .finished = status {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation])
    }

    func testHasInProgress_statusInProgress_shouldReturnTrue() async throws {
        let task = Task<CollectionResponse, Error> {
            try CollectionResponseMock.response
        }
        await sut.set(identifier: request, status: .inProgress(task))
        let hasInProgress = await sut.hasInProgress
        XCTAssertTrue(hasInProgress)
    }

    func testHasInProgress_statusFinished_shouldReturnFalse() async throws {
        let response = try CollectionResponseMock.response
        await sut.set(identifier: request, status: .finished(response))
        let hasInProgress = await sut.hasInProgress
        XCTAssertFalse(hasInProgress)
    }

    func testAllFinished_noStatuses_shouldReturnEmptyArray() async throws {
        let allFinished = await sut.allFinished
        XCTAssertTrue(allFinished.isEmpty)
    }

    func testResponses_statusInProgress_shouldReturnEmptyArray() async throws {
        let task = Task<CollectionResponse, Error> {
            try CollectionResponseMock.response
        }
        await sut.set(identifier: request, status: .inProgress(task))
        let allFinished = await sut.allFinished
        XCTAssertTrue(allFinished.isEmpty)
    }

    func testResponses_statusFinished_shouldReturnArrayWithResponse() async throws {
        let response = try CollectionResponseMock.response
        await sut.set(identifier: request, status: .finished(response))
        let allFinished = await sut.allFinished
        XCTAssertFalse(allFinished.isEmpty)
    }

    func testRemoveStatus_withStatusFinished_responsesShouldReturnEmptyArray() async throws {
        let response = try CollectionResponseMock.response
        await sut.set(identifier: request, status: .finished(response))
        await sut.removeStatus(for: request)
        let allFinished = await sut.allFinished
        XCTAssertTrue(allFinished.isEmpty)
    }

    func testRemoveAll_withStatusFinished_responsesShouldReturnEmptyArray() async throws {
        let response = try CollectionResponseMock.response
        await sut.set(identifier: request, status: .finished(response))
        await sut.removeAll()
        let allFinished = await sut.allFinished
        XCTAssertTrue(allFinished.isEmpty)
    }
}
