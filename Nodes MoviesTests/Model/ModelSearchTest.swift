//
//  ModelSearchTest.swift
//  Nodes MoviesTests
//
//  Created by Milan Horvatovic on 26/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import XCTest
@testable import Nodes_Movies

final class ModelSearchTests: XCTestCase {

    private typealias Expectation = (total: (results: Int, pages: Int), resultsCount: Int)
    private typealias Sample = (index: Int, expectation: Expectation)

}

// MARK: - Setup
extension ModelSearchTests {

    override class func setUp() {
        do {
            let fileManager = FileManager.default
            let url = self._storageURL()
            if fileManager.fileExists(atPath: url.path) == true {
                try fileManager.removeItem(at: url)
            }
            try fileManager.createDirectory(at: url,
                                            withIntermediateDirectories: true)
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }

}

// MARK: - Helpers
extension ModelSearchTests {

    private class func _storageURL() -> URL {
        let tempPath = NSTemporaryDirectory()
        return URL(fileURLWithPath: tempPath).appendingPathComponent("\(self)")
    }

}

// MARK: - Prepare
extension ModelSearchTests {

    private func _prepareSearchData(for index: Int) throws -> Data {
        guard let path = Bundle(for: type(of: self)).path(forResource: "search-\(index)", ofType: "json") else {
            fatalError("File not found")
        }
        return try self._prepareSearchData(from: URL(fileURLWithPath: path))
    }

    private func _prepareSearchData(from url: URL) throws -> Data {
        return try Data(contentsOf: url)
    }

}

// MARK: - Tests
extension ModelSearchTests {

    func test_searches() {
        do {
            let samples: [Sample] = [
                (1,
                 ((23, 2), 20)),
                (2,
                ((5, 1), 5))
            ]
            try samples.forEach({ (sample) in
                try self._test_search(for: sample)
            })
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }

    private func _test_search(for sample: Sample) throws {
        let laodedData = try self._prepareSearchData(for: sample.index)
        let loadedObject = try self._try_decode_search(from: laodedData)
        try self._try_search_values(from: loadedObject,
                                    with: sample.expectation)
        let url = try self._try_encode_search(for: sample,
                                              from: loadedObject)
        let storedData = try self._prepareSearchData(from: url)
        let storedObject = try self._try_decode_search(from: storedData)
        try self._try_search_values(from: storedObject,
                                    with: sample.expectation)
        try self._try_search_representations(lhs: loadedObject,
                                             rhs: storedObject)
    }

}

// MARK: - Try
// MARK: Decode
extension ModelSearchTests {

    private func _try_decode_search(from data: Data,
                                    with decoder: JSONDecoder = JSONDecoder()) throws -> Model.Service.Search {
        return try decoder.decode(Model.Service.Search.self,
                                  from: data)
    }

}

// MARK: Encode
extension ModelSearchTests {

    private func _try_encode_search(for sample: Sample,
                                    from data: Model.Service.Search,
                                    with encoder: JSONEncoder = JSONEncoder()) throws -> URL {
        let url = type(of: self)._storageURL().appendingPathComponent("\(sample.index)").appendingPathExtension("json")
        let encodedData = try encoder.encode(data)
        try encodedData.write(to: url)
        return url
    }

}

// MARK: Values
extension ModelSearchTests {

    private func _try_search_values(from model: Model.Service.Search,
                                    with expectation: Expectation) throws {
        XCTAssertEqual(model.result.total.results, expectation.total.results)
        XCTAssertEqual(model.result.total.pages, expectation.total.pages)
        XCTAssertEqual(model.results.count, expectation.resultsCount)
    }

    private func _try_search_representations(lhs: Model.Service.Search,
                                             rhs: Model.Service.Search) throws {
        XCTAssertEqual(lhs, rhs)
    }

}
