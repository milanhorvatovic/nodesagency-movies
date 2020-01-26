//
//  NetworkEngine.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 26/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

struct Request {
    
    enum InitError: Swift.Error {
        
        case base
        case relative
        
    }
    
    let url: URL
    
}

extension Request {
    
    private init(urlComponents: URLComponents,
                 relativePath: String,
                 queryItems: [URLQueryItem]? = nil) throws {
        var urlComponents = urlComponents
        let slashSet = CharacterSet(charactersIn: "/")
        let path = [urlComponents.path.trimmingCharacters(in: slashSet),
                    relativePath.trimmingCharacters(in: slashSet)]
            .joined(separator: "/")
        urlComponents.path = "/" + path
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            throw InitError.relative
        }
        self.init(url: url)
    }
    
    init(base: String,
         relativePath: String,
         queryItems: [URLQueryItem]? = nil) throws {
        guard let urlComponents = URLComponents(string: base) else {
            throw InitError.base
        }
        try self.init(urlComponents: urlComponents,
                      relativePath: relativePath)
    }
    
    init(base: URL,
         relativePath: String,
         queryItems: [URLQueryItem]? = nil) throws {
        guard let urlComponents = URLComponents(url: base,
                                                resolvingAgainstBaseURL: true)
            else {
            throw InitError.base
        }
        try self.init(urlComponents: urlComponents,
                      relativePath: relativePath,
                      queryItems: queryItems)
    }
    
}

protocol NetworkEngine {
    
    func perform(request: Request) -> Observable<Data>
    
    func cancelAllRequets()
    
}

extension URLSession: NetworkEngine {
    
    func perform(request: Request) -> Observable<Data> {
        let urlRequest = URLRequest(url: request.url)
        return self.rx.response(request: urlRequest)
            .filter({ (response, data) -> Bool in
                return 200..<399 ~= response.statusCode
            })
            .map({ (_, data) -> Data in
                return data
            })
    }
    
    func cancelAllRequets() {
        self.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            let cancel: (URLSessionTask) -> Void = { (task) in
                task.cancel()
            }
            dataTasks.forEach(cancel)
            uploadTasks.forEach(cancel)
            downloadTasks.forEach(cancel)
        }
    }
    
}
