//
//  FavoriteViewModel.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 26/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay
import Action

protocol FavoriteViewModel {

    typealias ModelType = Model.Service.Movie.Detail
    typealias SectionType = FavoriteSection

    typealias DataProviderType = FavoriteDataProvider

    var data: Observable<[SectionType]> { get }
    var error: Observable<Swift.Error> { get }

    var fetchAction: Action<Void, [ModelType]> { get }

    init(dataProvider: DataProviderType)

}

final class DefaultFavoriteViewModel: FavoriteViewModel {

    let dataProvider: DataProviderType

    private let _disposeBag: DisposeBag

    private let _data: BehaviorRelay<[SectionType]>
    var data: Observable<[SectionType]> {
        return self._data.asObservable()
    }
    var error: Observable<Swift.Error> {
        return .never()
    }
    var isLoading: Observable<Bool> {
        return .never()
    }

    private(set) lazy var fetchAction: Action<Void, [ModelType]> = self._createFetchAction()

    init(dataProvider: DataProviderType) {
        self.dataProvider = dataProvider
        self._disposeBag = DisposeBag()
        self._data = BehaviorRelay(value: [])

        self.fetchAction
            .elements
            .map({ (data) -> [SectionType] in
                return [SectionType(items: data)]
            })
            .bind(to: self._data)
            .disposed(by: self._disposeBag)
    }
 
}

// MARK: - Create
extension DefaultFavoriteViewModel {

    private func _createFetchAction() -> Action<Void, [ModelType]> {
        return Action { [unowned self] () -> Observable<[ModelType]> in
            return self.dataProvider.providerFavirites()
        }
    }

}
