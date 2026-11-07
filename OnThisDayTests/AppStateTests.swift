//
//  AppStateTests.swift
//  OnThisDayTests
//
//  Created by Kenneth Chua on 11/7/26.
//

import XCTest
@testable import OnThisDay

final class AppStateTests: XCTestCase {
    
    var appState: AppState!
    var mockSession: URLSession!
    
    @MainActor
    override func setUp() {
        super.setUp()
        
        // 1. Set up the session to use our MockURLProtocol
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: config)
        
        // 2. Inject it into AppState
        appState = AppState(session: mockSession)
    }
    
    override func tearDown() {
        appState = nil
        mockSession = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }
    
    @MainActor
    func testFetchDaySuccess() async throws {
        // Given: A successful mock network response using your testData
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, testData)
        }
        
        // When: Fetching the day
        await appState.fetchDay(month: 2, day: 29)
        
        // Then: The state should be loaded and the data decoded
        XCTAssertEqual(appState.loadState, .loaded)
        XCTAssertNotNil(appState.currentDay)
        
        // Verify the data actually decoded correctly
        let currentDay = try XCTUnwrap(appState.currentDay)
        XCTAssertEqual(currentDay.date, "February_29")
    }
    
    @MainActor
    func testFetchDayNetworkFailure() async throws {
        // Given: A simulated server error (e.g., 500 Internal Server Error)
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
        
        // When: Fetching the day
        await appState.fetchDay(month: 2, day: 29)
        
        // Then: The state should be failed and currentDay should be nil
        if case .failed(let errorMsg) = appState.loadState {
            XCTAssertFalse(errorMsg.isEmpty, "Error message should not be empty")
        } else {
            XCTFail("Expected loadState to be .failed, but got \(appState.loadState)")
        }
        XCTAssertNil(appState.currentDay)
    }
    
    @MainActor
    func testFetchDayDecodingFailure() async throws {
        // Given: Malformed JSON from the server
        let badData = """
        { "invalid": "json_structure" }
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, badData)
        }
        
        // When: Fetching the day
        await appState.fetchDay(month: 2, day: 29)
        
        // Then: The state should be failed (decoder threw an error)
        if case .failed(let errorMsg) = appState.loadState {
            XCTAssertFalse(errorMsg.isEmpty, "Error message should not be empty")
        } else {
            XCTFail("Expected loadState to be .failed due to decoding, but got \(appState.loadState)")
        }
        XCTAssertNil(appState.currentDay)
    }
}
