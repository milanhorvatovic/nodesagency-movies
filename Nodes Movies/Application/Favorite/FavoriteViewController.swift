//
//  FavoriteViewController.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 26/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import UIKit

import Strongify
import RxSwift
import RxCocoa
import RxDataSources

final class FavoriteViewController: UIViewController {

    typealias ViewModelType = FavoriteViewModel
    typealias CellType = FavoriteListCell
    typealias ContextType = Application.Context

    private static let _cellIdentifier: String = "FavoriteListCellIdentifier"

    private let _context: ContextType
    private let _viewModel: ViewModelType
    private var _disposeBag: DisposeBag

    @IBOutlet private weak var _tableView: UITableView!

    init(context: ContextType,
         viewModel: ViewModelType) {
        self._context = context
        self._viewModel = viewModel
        self._disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Favorited movies"

        self._disposeBag = DisposeBag()

        self.rx.viewWillAppearObservable
            .map({ (_) -> Void in
                return ()
            })
            .bind(to: self._viewModel.fetchAction)
            .disposed(by: self._disposeBag)

        self._tableView.register(UINib(nibName: "\(CellType.self)",
                                       bundle: Bundle(for: CellType.self)),
                                 forCellReuseIdentifier: type(of: self)._cellIdentifier)

        let dataSource = RxTableViewSectionedAnimatedDataSource<ViewModelType.SectionType>(
            configureCell: strongify(weak: self,
                                     return: UITableViewCell(),
                                     closure: { (self, dataSource, tableView, indexPath, item) -> UITableViewCell in
                                        guard let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self)._cellIdentifier,
                                                                                       for: indexPath) as? CellType
                                            else {
                                                fatalError("Couldn't create custom cell")
                                        }
                                        cell.configure(with: item)
                                        return cell
            }))
        let data = self._viewModel.data
            .debug("FAVORITE DATA:")
            .share(replay: 1,
                   scope: .forever)
        data
            .bind(to: self._tableView.rx.items(dataSource: dataSource))
            .disposed(by: self._disposeBag)
        if let backgroundView = self._tableView.backgroundView {
            data
                .map({ (data) -> CGFloat in
                    guard data.isEmpty == false else {
                        return 1.0
                    }
                    return data
                        .compactMap({ (section) -> Int in
                            return section.items.count
                        })
                        .reduce(0, +) > 0 ? 0.0 : 1.0
                })
                .distinctUntilChanged()
                .bind(to: backgroundView.rx.alpha)
                .disposed(by: self._disposeBag)
        }
        self._tableView.rx.modelSelected(ViewModelType.ModelType.self)
            .subscribe(onNext: strongify(weak: self, dataSource,
                                         closure: { (self, dataSource, item) in
                                            if let index = dataSource.sectionModels.first?.items.firstIndex(of: item) {
                                                self._tableView.deselectRow(at: IndexPath(row: index,
                                                                                          section: 0),
                                                                            animated: true)
                                            }
                                            self._didSelect(item: item)
            }))
            .disposed(by: self._disposeBag)
        self._tableView.tableFooterView = UIView()

        let searchItem = UIBarButtonItem(barButtonSystemItem: .search,
                                         target: nil,
                                         action: nil)
        self.navigationItem.rightBarButtonItem = searchItem
        searchItem.rx.tap
            .subscribe(onNext: strongify(weak: self, closure: { (self) in
                self._presentSearch()
            }))
            .disposed(by: self._disposeBag)
        print(NSHomeDirectory())
    }

}

extension FavoriteViewController {

    private func _presentSearch() {
        let viewModel = DefaultSearchViewModel(dataLoader: self._context.dataLoader)
        let viewController = SearchViewController(context: self._context,
                                                  viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController,
                     animated: true,
                     completion: nil)
    }

    private func _didSelect(item: ViewModelType.ModelType) {
        let viewModel = DefaultDetailViewModel(with: item,
                                               dataLoader: self._context.dataLoader,
                                               favoriteDataProvider: self._context.favoriteDataProvider)
        let viewController = DetailViewController(context: self._context,
                                                  viewModel: viewModel)
        self.navigationController?.pushViewController(viewController,
                                                      animated: true)
    }

}
