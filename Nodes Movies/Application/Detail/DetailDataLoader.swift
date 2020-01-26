//
//  DetailDataLoader.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 26/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import Foundation

import RxSwift

protocol DetailDataLoader {

    func loadDetail(for id: Int) -> Observable<Model.Service.Movie.Detail>

}

extension DataLoader: DetailDataLoader {

    func loadDetail(for id: Int) -> Observable<Model.Service.Movie.Detail> {
        do {
            let request = try self.constructRequest(with: "/movie/\(id)")
            return self.load(request: request)
        }
        catch {
            return Observable.error(error)
        }
    }

}
