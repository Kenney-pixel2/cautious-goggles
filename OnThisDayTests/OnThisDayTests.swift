//
//  OnThisDayTests.swift
//  OnThisDayTests
//
//  Created by Kenneth Chua on 10/21/26.
//

import XCTest
@testable import OnThisDay

final class OnThisDayTests: XCTestCase {

    func testJSONDecoderDecodesDayDate() throws {
        let decoder = JSONDecoder()
        let day = try decoder.decode(Day.self, from: testData)
        
        XCTAssertEqual(day.date, "February_29")
    }
    
    func testJSONDecoderDecodesDayData() throws {
        let decoder = JSONDecoder()
        let day = try decoder.decode(Day.self, from: testData)

        XCTAssertTrue(day.data.keys.contains("Births"))
    }
    
    func testJSONDecoderDecodesEventLinks() throws {
        let decoder = JSONDecoder()
        let day = try decoder.decode(Day.self, from: testData)

        let events = try XCTUnwrap(day.data["Events"])
        let firstEvent = try XCTUnwrap(events.first)
        let firstLink = try XCTUnwrap(firstEvent.links.first)

        XCTAssertEqual(firstLink.text, "888")
        XCTAssertEqual(firstLink.url, "https://en.wikipedia.org/wiki/AD_888")
    }
    
    func testDisplayDayDate() throws {
        let decoder = JSONDecoder()
        let day = try decoder.decode(Day.self, from: testData)
        
        XCTAssertEqual(day.displayDate, "February 29")
    }
    
    func testEventIsIdentifiableAndDecodesText() throws {
        let decoder = JSONDecoder()
        let day = try decoder.decode(Day.self, from: testData)
        
        let firstEvent = try XCTUnwrap(day.events.first)
        
        // Verify the text is decoded properly
        XCTAssertEqual(firstEvent.text, "888 – Odo, count of Paris, is crowned king of West Francia (France) by Archbishop Walter of Sens at Compiègne.")
        
        // Verify the Event generated a UUID
        XCTAssertNotNil(firstEvent.id)
    }
    
    func testLinkIsIdentifiableAndHasValidURL() throws {
        let decoder = JSONDecoder()
        let day = try decoder.decode(Day.self, from: testData)
        
        let firstEvent = try XCTUnwrap(day.events.first)
        let firstLink = try XCTUnwrap(firstEvent.links.first)
        
        // Verify the raw string properties decoded properly
        XCTAssertEqual(firstLink.text, "888")
        XCTAssertEqual(firstLink.url, "https://en.wikipedia.org/wiki/AD_888")
        
        // Verify the Identifiable UUID was generated
        let secondLink = try XCTUnwrap(firstEvent.links.dropFirst().first)
        XCTAssertNotEqual(firstLink.id, secondLink.id)
        
        // Verify the computed property successfully parses the string into a URL
        let parsedURL = try XCTUnwrap(firstLink.urlValue)
        XCTAssertEqual(parsedURL.host, "en.wikipedia.org")
    }
    
    func testEventInitSkipsMalformedLinks() throws {
        // 1. Create a custom JSON payload with a mix of valid and invalid links
        let badData = """
        {
            "date": "Test",
            "data": {
                "Events": [
                    {
                        "text": "Test Event",
                        "links": [
                            { "text": "Valid", "url": "https://apple.com" },
                            { "text": "Missing URL Key" },
                            { "text": "Invalid URL", "url": "" },
                            { "text": "Also Valid", "url": "https://swift.org" }
                        ]
                    }
                ]
            }
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        
        // 2. Ensure the entire Day decodes without throwing
        let day = try decoder.decode(Day.self, from: badData)
        
        let event = try XCTUnwrap(day.events.first)
        
        // 3. The event should have successfully decoded
        XCTAssertEqual(event.text, "Test Event")
        
        // 4. Out of the 4 links in the JSON, only the 2 valid ones should remain
        XCTAssertEqual(event.links.count, 2)
        
        // 5. Verify the specific links that survived
        XCTAssertEqual(event.links[0].text, "Valid")
        XCTAssertEqual(event.links[1].text, "Also Valid")
    }
}
