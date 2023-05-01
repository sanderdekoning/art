//
//  TaskStatusStore.swift
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

    func testDidRequest_withNoStatuses_shouldReturnFalse() async throws {
        let didRequest = await sut.didRequest(request: request)
        XCTAssertFalse(didRequest)
    }

    func testDidRequest_withInProgressStatus_shouldReturnTrue() async throws {
        let task = Task<CollectionResponse, Error> {
            try CollectionResponseMock.response
        }
        await sut.set(request: request, status: .inProgress(task))
        let didRequest = await sut.didRequest(request: request)
        XCTAssertTrue(didRequest)
    }

    func testStatusForRequest_statusInProgress_shouldReturnInProgress() async throws {
        let task = Task<CollectionResponse, Error> {
            return try CollectionResponseMock.response
        }
        await sut.set(request: request, status: .inProgress(task))
        let status = await sut.status(for: request)
        let expectation = XCTestExpectation(description: "Task status equals in progress")
        if case .inProgress = status {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation])
    }

    func testStatusForRequest_statusFinished_shouldReturnFinishedResponse() async throws {
        let response = try CollectionResponseMock.response
        await sut.set(request: request, status: .finished(response))
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
        await sut.set(request: request, status: .inProgress(task))
        let hasInProgress = await sut.hasInProgress
        XCTAssertTrue(hasInProgress)
    }

    func testHasInProgress_statusFinished_shouldReturnFalse() async throws {
        let response = try CollectionResponseMock.response
        await sut.set(request: request, status: .finished(response))
        let hasInProgress = await sut.hasInProgress
        XCTAssertFalse(hasInProgress)
    }

    func testResponses_noStatuses_shouldReturnEmptyArray() async throws {
        let responses = await sut.responses
        XCTAssertTrue(responses.isEmpty)
    }

    func testResponses_statusInProgress_shouldReturnEmptyArray() async throws {
        let task = Task<CollectionResponse, Error> {
            try CollectionResponseMock.response
        }
        await sut.set(request: request, status: .inProgress(task))
        let responses = await sut.responses
        XCTAssertTrue(responses.isEmpty)
    }

    func testResponses_statusFinished_shouldReturnArrayWithResponse() async throws {
        let response = try CollectionResponseMock.response
        await sut.set(request: request, status: .finished(response))
        let responses = await sut.responses
        XCTAssertFalse(responses.isEmpty)
    }

    func testRemoveStatus_withStatusFinished_responsesShouldReturnEmptyArray() async throws {
        let response = try CollectionResponseMock.response
        await sut.set(request: request, status: .finished(response))
        await sut.removeStatus(for: request)
        let responses = await sut.responses
        XCTAssertTrue(responses.isEmpty)
    }

    func testRemoveAll_withStatusFinished_responsesShouldReturnEmptyArray() async throws {
        let response = try CollectionResponseMock.response
        await sut.set(request: request, status: .finished(response))
        await sut.removeAll()
        let responses = await sut.responses
        XCTAssertTrue(responses.isEmpty)
    }
}
