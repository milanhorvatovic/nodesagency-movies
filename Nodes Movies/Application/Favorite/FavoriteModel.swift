//
//  FavoriteModel.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 26/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import Foundation

import RxDataSources

extension Model.Service.Movie.Detail: IdentifiableType {

    var identity: Int {
        return self.id
    }

}

struct FavoriteSection {

    typealias Item = Model.Service.Movie.Detail

    var header: String = "Favorited movies"
    var items: [Item]

}

extension FavoriteSection: AnimatableSectionModelType {

    var identity: String {
        return self.header
    }

    init(original: Self,
         items: [Self.Item]) {
        self = original
        self.items = items
    }

}
