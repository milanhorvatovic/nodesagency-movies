//
//  ApplicationFactory.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 27/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import UIKit

enum Application {
    
}

extension Application {

    struct Context {

        typealias DataLoaderType = SearchDataLoader & DetailDataLoader

        private let engine: NetworkEngine
        let dataLoader: DataLoaderType

        let favoriteDataProvider: FavoriteDataProvider

        fileprivate init(engine: NetworkEngine,
                         dataLoader: DataLoaderType,
                         favoriteDataProvider: FavoriteDataProvider) {
            self.engine = engine
            self.dataLoader = dataLoader
            self.favoriteDataProvider = favoriteDataProvider
        }

    }

}

extension Application {

    enum Factory {

        static func createApplication() -> (UIWindow, Context) {
            do {
                let window = UIWindow(frame: UIScreen.main.bounds)
                let networkEngine = URLSession(configuration: URLSessionConfiguration.default)
                let dataLoader = try DataLoader(base: "https://api.themoviedb.org/3",
                                                  engine: networkEngine)
                let dataProvider = DefaultFavoriteDataProvider()
                let context = Context(engine: networkEngine,
                                      dataLoader: dataLoader,
                                      favoriteDataProvider: dataProvider)
                let viewModel = DefaultFavoriteViewModel(dataProvider: dataProvider)
                let viewController = FavoriteViewController(context: context,
                                                            viewModel: viewModel)
                window.rootViewController = UINavigationController(rootViewController: viewController)
                window.makeKeyAndVisible()
                return (window, context)
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }

    }

}
