//
//  MovieServiceTests.swift
//  MovieAppTests
//
//  Created by Yuri Ramocan on 8/17/18.
//  Copyright © 2018 yuriramocan. All rights reserved.
//

import Mockingjay
@testable import MovieApp
import XCTest

class MovieServiceTests: XCTestCase {

    private var service: MovieService!
    
    override func setUp() {
        super.setUp()

        service = MovieService()
    }

    // NOTE: These are basic tests but should cover the network functionality of this app.

    func testCanGetNowPlayingMoviesSuccessfully() {
        let expectation = XCTestExpectation(description: "Movies retrieved successfully")

        movieStub(.get, "movie/now_playing", fixture: "get-movies-success")

        service.getMovies(type: .nowPlaying) { result in
            defer { expectation.fulfill() }

            guard case .success(let movies) = result else {
                XCTFail("Get movies was not successful")
                return
            }

            XCTAssertEqual(movies.count, 20)
        }

        wait(for: [expectation], timeout: 5)
    }

    func testGetNowPlayingMoviesWithInvalidAPIKeyFailsAndReturnsError() {
        let expectation = XCTestExpectation(description: "Movies retrieval failed and returns error")

        movieStub(.get, "movie/now_playing", fixture: "get-movies-api-key-failure")

        service.getMovies(type: .nowPlaying) { result in
            defer { expectation.fulfill() }

            guard case .failure(let error) = result else {
                XCTFail("Get movies unexpectedly succeeded")
                return
            }

            XCTAssertNotNil(error)
        }

        wait(for: [expectation], timeout: 5)
    }
    
}
