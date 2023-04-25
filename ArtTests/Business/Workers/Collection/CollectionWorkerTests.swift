//
//  ArtTests.swift
//  ArtTests
//
//  Created by Sander de Koning on 19/04/2023.
//

import XCTest
@testable import Art

final class CollectionWorkerTests: XCTestCase {
    var sut: CollectionWorker!
    let request = CollectionRequest(resultsPerPage: 50, page: 1)

    override func setUpWithError() throws {
        executionTimeAllowance = 5
        
        sut = CollectionWorker(session: .mocked)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testCollection_nonHTTPURLResponse_shouldThrowUnexpectedResponseError() async throws {
        let url = try request.url
        let urlResponse = URLResponse(
            url: url,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )

        let response = URLProtocolMock.MockURLResponse(
            response: urlResponse,
            data: CollectionResponseMock.collection
        )
        
        URLProtocolMock.requestHandler = { _ in response }
        
        let task = Task {
            try await sut.collection(for: request)
        }
        let result = await task.result

        XCTAssertThrowsError(try result.get()) { error in
            XCTAssertEqual(error as? CollectionWorkerError, .unexpectedResponse(url))
        }
    }
    
    func testCollection_statusCode200_shouldReturnExpectedPageAndObjects() async throws {
        let httpResponse = try XCTUnwrap(HTTPURLResponse(
            url: try request.url,
            statusCode: 200,
            httpVersion: "2.0",
            headerFields: nil
        ))

        let response = URLProtocolMock.MockURLResponse(
            response: httpResponse,
            data: CollectionResponseMock.collection
        )
        
        URLProtocolMock.requestHandler = { _ in response }
        
        let collection = try await sut.collection(for: request)
        
        // Asserting against literals as the mock JSON response contains static data
        XCTAssertEqual(collection.page, 1)
        XCTAssertEqual(collection.response.artObjects.count, 50)
        XCTAssertEqual(collection.response.artObjects[42].id, "en-KOG-MP-2-0258")
    }
    
    func testCollection_statusCode400_shouldThrowUnexpectedStatusCode400Error() async throws {
        let httpResponse = try XCTUnwrap(HTTPURLResponse(
            url: try request.url,
            statusCode: 400,
            httpVersion: "2.0",
            headerFields: nil
        ))

        let response = URLProtocolMock.MockURLResponse(
            response: httpResponse,
            data: CollectionResponseMock.collection
        )
        
        URLProtocolMock.requestHandler = { _ in response }

        let task = Task {
            try await sut.collection(for: request)
        }
        let result = await task.result

        XCTAssertThrowsError(try result.get()) { error in
            XCTAssertEqual(error as? CollectionWorkerError, .unexpectedStatusCode(400))
        }
    }
}
