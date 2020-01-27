//
//  ResourcesHelper.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 27/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import Foundation

enum Resources {

}

extension Resources {

    enum Helper {

    }

}

extension Resources.Helper {

    private static let imageBasePath: String = "https://image.tmdb.org/t/p/original/"
    private static let basicTrim: CharacterSet = CharacterSet.whitespacesAndNewlines
    private static let slashTrim: CharacterSet = CharacterSet(charactersIn: "/")

    static func imageUrl<ModelType>(with model: ModelType) -> URL? where ModelType: ModelServiceMovie {
        let path = [self.imageBasePath,
                    model.image.poster]
            .compactMap({ $0?.trimmingCharacters(in: self.basicTrim).trimmingCharacters(in: self.slashTrim) })
            .joined(separator: "/")
        return URL(string: path)
    }

}
