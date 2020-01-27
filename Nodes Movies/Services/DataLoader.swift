//
//  DataLoader.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 26/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import Foundation

import RxSwift
import RxSwiftExt

import Alamofire
import RxAlamofire

final class DataLoader {

    private static let apiKey: String = "4cb1eeab94f45affe2536f2c684a5c9e"

    enum InitError: Swift.Error {

        case invalidBase

    }

    enum LoadingError: Swift.Error {

        case network
        case noConnection
        case mapping

    }

    let baseURL: URL
    let engine: NetworkEngine

    // MARK: - Init
    init(base: String,
         engine: NetworkEngine) throws {
        guard let url = URL(string: base) else {
            throw Error(with: InitError.invalidBase)
        }
        self.baseURL = url
        self.engine = engine
    }

}

// MARK: Request
extension DataLoader {

    func constructRequest(with relativePath: String,
                          attributes queryAttributes: [String: String]? = nil) throws -> Request {
        var attributes = ["api_key": type(of: self).apiKey]
        queryAttributes?.forEach({ (key, value) in
            attributes.updateValue(value, forKey: key)
        })
        return try Request(base: self.baseURL,
                           relativePath: relativePath,
                           queryItems: attributes.map({ (key, value) -> URLQueryItem in
                            return URLQueryItem(name: key, value: value)
                           }))
    }

}

// MARK: Load
extension DataLoader {

    func load<ObjectType>(request: Request) -> Observable<ObjectType> where ObjectType: Decodable {
        return self.engine
            .perform(request: request)
            //.debug("Received data:")
            .catchError({ (error) -> Observable<Data> in
                guard let urlError = error as? URLError,
                    [URLError.networkConnectionLost,
                     URLError.timedOut].contains(urlError.code) else {
                        return Observable.error(Error(with: LoadingError.network, underlyingError: error))
                }
                return Observable.error(Error(with: LoadingError.noConnection, underlyingError: error))
            })
            .map({ (data) -> ObjectType in
                return try JSONDecoder().decode(ObjectType.self,
                                                from: data)
            })
            .catchError({ (error) -> Observable<ObjectType> in
                guard error is DecodingError else {
                    return Observable.error(error)
                }
                return Observable.error(Error(with: LoadingError.mapping,
                                              underlyingError: error))
            })
            //.debug("Received object:")
            .share(replay: 1,
                   scope: .forever)
    }

}

extension DataLoader.InitError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .invalidBase:
            return "An instance couldn't be constructed due to invalid base URL string representation. Please contact support."
        }
    }

}

extension DataLoader.LoadingError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .network:
            return "The operation couldn’t be completed due to complication(s) with the network. Please check your connection."
        case .noConnection:
            return "The operation couldn’t be completed due to there is no internet connection. Please check your connection."
        case .mapping:
            return "The operation couldn’t be completed due to error(s) with mapping. Please contact support."
        }
    }

}
