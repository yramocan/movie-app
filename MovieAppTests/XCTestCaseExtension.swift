//
//  XCTestCaseExtension.swift
//  MovieAppTests
//

import XCTest
import Mockingjay

extension XCTestCase {

    func loadFixture(_ filename: String) -> Data? {
        guard let fixturePath = Bundle(for: MovieServiceTests.self).path(forResource: filename, ofType: "json") else {
            return nil
        }

        let fixtureURL = URL(fileURLWithPath: fixturePath)

        return try? Data(contentsOf: fixtureURL)
    }

    func movieStub(_ httpMethod: HTTPMethod, _ uri: String, fixture: String? = nil, statusCode: Int = 200) {
        let responseData: Download

        if let fixture = fixture {
            guard let fixtureData = loadFixture(fixture) else {
                XCTFail("Unable to load fixture")
                return
            }

            responseData = .content(fixtureData)
        } else {
            responseData = .noContent
        }

        let requestMatcher = http(httpMethod, uri: "/3/\(uri)")
        let responseBuilder = http(statusCode, headers: nil, download: responseData)

        stub(requestMatcher, responseBuilder)
    }

}
