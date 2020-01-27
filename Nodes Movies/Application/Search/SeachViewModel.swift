//
//  SeachViewModel.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 27/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay
import Action

protocol SearchViewModel {

    typealias ModelType = Model.Service.Movie.Result
    typealias ServiceModelType = Model.Service.Search
    typealias SectionType = SearchSection

    typealias DataLoaderType = SearchDataLoader

    var data: Observable<[SectionType]> { get }
    var error: Observable<Swift.Error> { get }

    var fetchAction: Action<String, ServiceModelType> { get }

    init(dataLoader: DataLoaderType)

}

final class DefaultSearchViewModel: SearchViewModel {

    let dataLoader: DataLoaderType

    private let _disposeBag: DisposeBag

    private let _pagesInfo: BehaviorRelay<Model.Service.PageResult?>
    private let _data: BehaviorRelay<[SectionType]>
    private(set) lazy var data: Observable<[SectionType]> = {
        return self._data.asObservable()
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

    private(set) lazy var fetchAction: Action<String, ServiceModelType> = self._createFetchAction()

    init(dataLoader: DataLoaderType) {
        self.dataLoader = dataLoader
        self._disposeBag = DisposeBag()
        self._pagesInfo = BehaviorRelay(value: nil)
        self._data = BehaviorRelay(value: [])

        let fetch = self.fetchAction
            .elements
            .share(replay: 1,
                   scope: .forever)
        fetch
            .map({ (result) -> [SectionType] in
                return [SectionType(items: result.results)]
            })
            .bind(to: self._data)
            .disposed(by: self._disposeBag)
        
    }
 
}

// MARK: - Create
extension DefaultSearchViewModel {

    private func _createFetchAction() -> Action<String, ServiceModelType> {
        return Action { [unowned self] (term) -> Observable<ServiceModelType> in
            return self.dataLoader.loadSearch(for: term)
        }
    }

}
