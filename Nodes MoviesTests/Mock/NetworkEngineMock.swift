//
//  NetworkEngineMock.swift
//  Nodes MoviesTests
//
//  Created by Milan Horvatovic on 26/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import XCTest
@testable import Nodes_Movies

import RxSwift

enum NetworkEngineMock {

}

extension NetworkEngineMock {

    static func realMock() -> NetworkEngine {
        return URLSession(configuration: URLSessionConfiguration.default)
    }

}
