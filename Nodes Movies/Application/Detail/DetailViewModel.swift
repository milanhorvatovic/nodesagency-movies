//
//  DetailViewModel.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 27/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay
import Action

protocol DetailViewModel {

    typealias ModelType = Model.Service.Movie.Detail

    typealias DataLoaderType = DetailDataLoader

    var data: Observable<ModelType?> { get }
    var error: Observable<Swift.Error> { get }
    var isFavorited: Observable<Bool> { get }

    var fetchAction: Action<Void, ModelType> { get }

    var favoriteAction: Action<Void, Void> { get }
    var unfavoriteAction: Action<Void, Void> { get }

    init<ModelType>(with model: ModelType,
                    dataLoader: DataLoaderType,
                    favoriteDataProvider: FavoriteDataProvider) where ModelType: ModelServiceMovie

}

final class DefaultDetailViewModel: DetailViewModel {

    let dataLoader: DataLoaderType
    let favoritedDataLoader: FavoriteDataProvider

    private let _disposeBag: DisposeBag

    private let _id: Int
    private let _data: BehaviorRelay<ModelType?>
    private(set) lazy var data: Observable<ModelType?> = {
        return self._data
            .asObservable()
            .observeOn(MainScheduler.instance)
    }()
    private(set) lazy var error: Observable<Swift.Error> = {
        return self.fetchAction.underlyingError
            .observeOn(MainScheduler.asyncInstance)
            .share(replay: 1,
                   scope: .forever)
    }()
    private(set) lazy var isLoading: Observable<Bool> = {
        return self.fetchAction.executing
            .observeOn(MainScheduler.asyncInstance)
            .share(replay: 1,
                   scope: .forever)
    }()
    private(set) lazy var isFavorited: Observable<Bool> = {
        return Observable.combineLatest(self.fetchAction.elements,
                                        self.favoritedDataLoader.providerFavirites())
            .map({ (movie, favorited) -> Bool in
                return favorited.contains(movie)
            })
            .observeOn(MainScheduler.instance)
    }()

    private(set) lazy var fetchAction: Action<Void, ModelType> = self._createFetchAction()

    private(set) lazy var favoriteAction: Action<Void, Void> = self._createFavoriteAction()
    private(set) lazy var unfavoriteAction: Action<Void, Void> = self._createUnfavoriteAction()

    init<ModelType>(with model: ModelType,
                    dataLoader: DataLoaderType,
                    favoriteDataProvider: FavoriteDataProvider) where ModelType: ModelServiceMovie {
        self._id = model.id as! Int
        self.dataLoader = dataLoader
        self.favoritedDataLoader = favoriteDataProvider
        self._disposeBag = DisposeBag()
        self._data = BehaviorRelay(value: nil)

        self.fetchAction
            .elements
            .bind(to: self._data)
            .disposed(by: self._disposeBag)

        self.favoriteAction
            .elements
            .withLatestFrom(self.data)
            .filterNil()
//            .debug("FAVORITE:")
            .bind(to: self.favoritedDataLoader.favoriteAction)
            .disposed(by: self._disposeBag)
        self.unfavoriteAction
            .elements
            .withLatestFrom(self.data)
            .filterNil()
//            .debug("UNFAVORITE:")
            .bind(to: self.favoritedDataLoader.unfavoriteAction)
            .disposed(by: self._disposeBag)
    }
 
}

// MARK: - Create
extension DefaultDetailViewModel {

    private func _createFetchAction() -> Action<Void, ModelType> {
        return Action { [unowned self] () -> Observable<ModelType> in
            return self.dataLoader.loadDetail(for: self._id)
        }
    }

    private func _createFavoriteAction() -> Action<Void, Void> {
        return Action { () -> Observable<Void> in
            return Observable.just(())
        }
    }

    private func _createUnfavoriteAction() -> Action<Void, Void> {
        return Action { () -> Observable<Void> in
            return Observable.just(())
        }
    }

}
