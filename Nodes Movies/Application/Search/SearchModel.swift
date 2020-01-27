//
//  SearchModel.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 27/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import Foundation

import RxDataSources

extension Model.Service.Movie.Result: IdentifiableType {

    var identity: Int {
        return self.id
    }

}

struct SearchSection {

    typealias Item = Model.Service.Movie.Result

    var header: String = "Search result"
    var items: [Item]

}

extension SearchSection: AnimatableSectionModelType {

    var identity: String {
        return self.header
    }

    init(original: Self,
         items: [Self.Item]) {
        self = original
        self.items = items
    }

}
