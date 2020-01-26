//
//  SearchDataLoader.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 26/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import Foundation

import RxSwift

protocol SearchDataLoader {

    func loadSearch(for term: String) -> Observable<Model.Service.Search>

}

extension DataLoader: SearchDataLoader {

    func loadSearch(for term: String) -> Observable<Model.Service.Search> {
        do {
            let request = try self.constructRequest(with: "/search/movie",
                                                    attributes: ["query": term])
            return self.load(request: request)
        }
        catch {
            return Observable.error(error)
        }
    }

}
