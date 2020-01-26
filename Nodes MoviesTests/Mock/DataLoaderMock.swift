//
//  DataLoaderMock.swift
//  Nodes MoviesTests
//
//  Created by Milan Horvatovic on 26/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import XCTest
@testable import Nodes_Movies

import RxSwift

enum DataLoaderMock {

}

extension DataLoaderMock {

    static func realMock(with engine: NetworkEngine) throws -> DataLoader {
        return try DataLoader(base: "https://api.themoviedb.org/3",
                              engine: engine)
    }

}

