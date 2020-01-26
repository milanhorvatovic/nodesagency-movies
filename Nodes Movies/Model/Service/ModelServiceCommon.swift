//
//  ModelServiceCommon.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 26/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import Foundation

extension Model.Service {

    struct Vote {

        let average: Double
        let count: Int

    }

}

extension Model.Service.Vote: Codable {

    private enum CodingKeys: String, CodingKey {

        case average = "vote_average"
        case count = "vote_count"

    }

}

extension Model.Service.Vote : Equatable { }

extension Model.Service {

    struct Title {

        let original: String
        let localized: String
        let language: String

    }
}

extension Model.Service.Title: Codable {

    private enum CodingKeys: String, CodingKey {

        case original = "original_title"
        case localized = "title"
        case language = "original_language"

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.original = try container.decode(String.self,
                                             forKey: .original)
        self.localized = try container.decode(String.self,
                                              forKey: .localized)
        self.language = try container.decode(String.self,
                                             forKey: .language)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.original,
                             forKey: .original)
        try container.encode(self.localized,
                             forKey: .localized)
        try container.encode(self.language,
                             forKey: .language)
    }

}

extension Model.Service.Title: Equatable { }

extension Model.Service {

    struct Image {

        let poster: String?
        let backdrop: String?

    }

}

extension Model.Service.Image: Codable {

    private enum CodingKeys: String, CodingKey {

        case poster = "poster_path"
        case backdrop = "backdrop_path"

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.poster = try container.decodeIfPresent(String.self,
                                                    forKey: .poster)
        self.backdrop = try container.decodeIfPresent(String.self,
                                                      forKey: .backdrop)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.poster,
                             forKey: .poster)
        try container.encode(self.backdrop,
                             forKey: .backdrop)
    }

}

extension Model.Service.Image: Equatable { }

extension Model.Service {

    struct PageResult {

        let page: Int
        let total: Model.Service.Total

    }

}

extension Model.Service.PageResult: Codable {

    private enum CodingKeys: String, CodingKey {

        case page
        case total

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.page = try container.decode(Int.self,
                                         forKey: .page)
        self.total = try Model.Service.Total(from: decoder)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.page,
                             forKey: .page)
        try self.total.encode(to: encoder)
    }

}

extension Model.Service.PageResult: Equatable { }

extension Model.Service {

    struct Total {

        let results: Int
        let pages: Int

    }

}

extension Model.Service.Total: Codable {

    private enum CodingKeys: String, CodingKey {

        case results = "total_results"
        case pages = "total_pages"

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.results = try container.decode(Int.self,
                                            forKey: .results)
        self.pages = try container.decode(Int.self,
                                          forKey: .pages)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.results,
                             forKey: .results)
        try container.encode(self.pages,
                             forKey: .pages)
    }

}

extension Model.Service.Total: Equatable { }
