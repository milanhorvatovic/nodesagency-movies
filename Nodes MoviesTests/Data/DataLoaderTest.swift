//
//  DataLoaderTest.swift
//  Nodes MoviesTests
//
//  Created by Milan Horvatovic on 26/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import XCTest
@testable import Nodes_Movies

import RxBlocking

final class DataLoaderTest: XCTestCase {

    private typealias ExpectationSearch = (total: (results: Int, pages: Int), resultsCount: Int)
    private typealias SampleSearch = (query: String, expectation: ExpectationSearch)

    private typealias ExpectationDetail = (id: Int, title: String, releaseDate: String)
    private typealias SampleDetail = (id: Int, expectation: ExpectationDetail)

}

// MARK: - Prepare
extension DataLoaderTest {

    private func _prepareRealLoader(with engine: NetworkEngine) throws -> DataLoader {
        return try DataLoaderMock.realMock(with: engine)
    }

    private func _prepareRealNetworkEngine() -> NetworkEngine {
        return NetworkEngineMock.realMock()
    }

}

//MARK: - Tests
extension DataLoaderTest {

    func testSearch() {
        do {
            let loader = try self._prepareRealLoader(with: self._prepareRealNetworkEngine())

            let samples: [SampleSearch] = [
                ("minions",
                ((23, 2), 20)),
                ("pulp fiction",
                 ((5, 1), 5))
            ]

            try samples.forEach({ (sample) in
                try self._try(sample: sample,
                              through: loader)
            })
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testDetail() {
        do {
            let loader = try self._prepareRealLoader(with: self._prepareRealNetworkEngine())

            let samples: [SampleDetail] = [
                (211672,
                (211672, "Minions", "2015-06-17")),
                (680,
                 (680, "Pulp Fiction", "1994-09-10"))
            ]

            try samples.forEach({ (sample) in
                try self._try(sample: sample,
                              through: loader)
            })
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }

}

// MARK: - Try
extension DataLoaderTest {

    private func _try(sample: SampleSearch,
                      through loader: DataLoader) throws {
        let result = try loader.loadSearch(for: sample.query).toBlocking().first()
        XCTAssertNotNil(result)
        guard let object = result else {
            return
        }
        XCTAssertEqual(object.result.total.results, sample.expectation.total.results)
        XCTAssertEqual(object.result.total.pages, sample.expectation.total.pages)
        XCTAssertEqual(object.results.count, sample.expectation.resultsCount)
    }

    private func _try(sample: SampleDetail,
                      through loader: DataLoader) throws {
        XCTAssertEqual(sample.id, sample.expectation.id)
        let result = try loader.loadDetail(for: sample.id).toBlocking().first()
        XCTAssertNotNil(result)
        guard let object = result else {
            return
        }
        XCTAssertEqual(object.id, sample.expectation.id)
        XCTAssertEqual(object.title.localized, sample.expectation.title)
        XCTAssertEqual(object.releaseDate, sample.expectation.releaseDate)
    }

}
