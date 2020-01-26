//
//  ModelServiceSearch.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 26/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import Foundation

extension Model.Service {

    struct Search {

        let result: Model.Service.PageResult
        let results: [Model.Service.Movie.Result]
        
    }
}

extension Model.Service.Search: Codable {

    private enum CodingKeys: String, CodingKey {

        case result
        case results

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.result = try Model.Service.PageResult(from: decoder)
        self.results = try container.decode([Model.Service.Movie.Result].self,
                                            forKey: .results)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try self.result.encode(to: encoder)
        try container.encode(self.results,
                             forKey: .results)
    }

}

extension Model.Service.Search: Equatable { }
