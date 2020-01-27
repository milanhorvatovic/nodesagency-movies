//
//  FavoriteDataProvider.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 26/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay
import Action

protocol FavoriteDataProvider {

    var favoriteAction: Action<Model.Service.Movie.Detail, [Model.Service.Movie.Detail]> { get }
    var unfavoriteAction: Action<Model.Service.Movie.Detail, [Model.Service.Movie.Detail]> { get }

    func providerFavirites() -> Observable<[Model.Service.Movie.Detail]>

}

final class DefaultFavoriteDataProvider: FavoriteDataProvider {

    private(set) lazy var favorited: BehaviorRelay<[Model.Service.Movie.Detail]> = self.createFavorited()

    private(set) lazy var favoriteAction: Action<Model.Service.Movie.Detail, [Model.Service.Movie.Detail]> = {
        return Action(workFactory: { [unowned self] (movie) -> Observable<[Model.Service.Movie.Detail]> in
            return Observable.just(movie)
                .withLatestFrom(self.favorited, resultSelector: { ($0, $1) })
                .filter({ (movie, movies) -> Bool in
                    return !movies.contains(movie)
                })
                .map({ (movie, movies) -> [Model.Service.Movie.Detail] in
                    var movies = movies
                    movies.append(movie)
                    return movies
                })
        })
    }()

    private(set) lazy var unfavoriteAction: Action<Model.Service.Movie.Detail, [Model.Service.Movie.Detail]> = {
        return Action(workFactory: { [unowned self] (movie) -> Observable<[Model.Service.Movie.Detail]> in
            return Observable.just(movie)
                .withLatestFrom(self.favorited, resultSelector: { ($0, $1) })
                .filter({ (movie, movies) -> Bool in
                    return movies.contains(movie)
                })
                .map({ (movie, movies) -> [Model.Service.Movie.Detail] in
                    var movies = movies
                    movies.removeAll(where: { (element) -> Bool in
                        return element == movie
                    })
                    return movies
                })
        })
    }()

    private let disposeBag: DisposeBag

    init() {
        self.disposeBag = DisposeBag()

        self.favoriteAction.elements
            .distinctUntilChanged()
            .bind(to: self.favorited)
            .disposed(by: self.disposeBag)
        self.unfavoriteAction.elements
            .distinctUntilChanged()
            .bind(to: self.favorited)
            .disposed(by: self.disposeBag)
        self.favorited
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] (favorited) in
                do {
                    try self.store(favorited)
                }
                catch {
                    fatalError("Storing was unsuccessful")
                }
            })
            .disposed(by: self.disposeBag)
    }

    func providerFavirites() -> Observable<[Model.Service.Movie.Detail]> {
        return self.favorited.asObservable()
    }

}

extension DefaultFavoriteDataProvider {

    private func createFavorited() -> BehaviorRelay<[Model.Service.Movie.Detail]> {
        do {
            return try BehaviorRelay(value: self.load())
        }
        catch {
            return BehaviorRelay(value: [])
        }
    }

}

extension DefaultFavoriteDataProvider {

    private static let key: String = "objects"

    private func storage() -> UserDefaults {
        guard let storage = UserDefaults(suiteName: "Favorited") else {
            fatalError("Storage couldn't be initialized")
        }
        return storage
    }

    private func load() throws -> [Model.Service.Movie.Detail] {
        let storage = self.storage()
        guard let data = storage.object(forKey: type(of: self).key) as? Data else {
            return []
        }
        let decoder = JSONDecoder()
        return try decoder.decode([Model.Service.Movie.Detail].self,
                                  from: data)
    }

    private func store(_ objects: [Model.Service.Movie.Detail]) throws {
        let storage = self.storage()
        let encoder = JSONEncoder()
        let data = try encoder.encode(objects)
        storage.set(data,
                    forKey: type(of: self).key)
        storage.synchronize()
    }

}
