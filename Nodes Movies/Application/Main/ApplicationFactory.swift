//
//  ApplicationFactory.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 27/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import UIKit

enum ApplicationFactory {
    
    static func createApplication() -> UIWindow {
        do {
            let window = UIWindow(frame: UIScreen.main.bounds)
            let _ = try DataLoader(base: "https://api.themoviedb.org/3",
                                   engine: URLSession(configuration: URLSessionConfiguration.default))
            let dataProvider = DefaultFavoriteDataProvider()
            let viewModel = DefaultFavoriteViewModel(dataProvider: dataProvider)
            let viewController = FavoriteViewController(viewModel: viewModel)
            window.rootViewController = UINavigationController(rootViewController: viewController)
            window.makeKeyAndVisible()
            return window
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
}

