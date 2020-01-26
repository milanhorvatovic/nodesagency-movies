//
//  ModelServiceMovie.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 26/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import Foundation

extension Model.Service {

    enum Movie {

    }

}

protocol ModelServiceMovie: Identifiable {

    var id: ID { get }
    var title: Model.Service.Title { get }
    var overview: String { get }
    var vote: Model.Service.Vote { get }
    var image: Model.Service.Image { get }
    var releaseDate: String { get }

}

protocol ModelServiceMovieDetailed: ModelServiceMovie {

}
