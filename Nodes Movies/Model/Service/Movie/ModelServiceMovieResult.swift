//
//  ModelServiceMovieResult.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 26/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import Foundation

extension Model.Service.Movie {

    struct Result: ModelServiceMovie {

        typealias ID = Int

        let id: ID
        let title: Model.Service.Title
        let overview: String
        let vote: Model.Service.Vote
        let image: Model.Service.Image
        let releaseDate: String

    }

}

extension Model.Service.Movie.Result: Codable {

    private enum CodingKeys: String, CodingKey {

        case id
        case title
        case overview
        case vote
        case image
        case releaseDate = "release_date"

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(ID.self,
                                       forKey: .id)
        self.title = try Model.Service.Title(from: decoder)
        self.overview = try container.decode(String.self,
                                             forKey: .overview)
        self.vote = try Model.Service.Vote(from: decoder)
        self.image = try Model.Service.Image(from: decoder)
        self.releaseDate = try container.decode(String.self,
                                                forKey: .releaseDate)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id,
                             forKey: .id)
        try self.title.encode(to: encoder)
        try container.encode(self.overview,
                             forKey: .overview)
        try self.vote.encode(to: encoder)
        try self.image.encode(to: encoder)
        try container.encode(self.releaseDate,
                             forKey: .releaseDate)
    }

}

extension Model.Service.Movie.Result: Equatable { }
