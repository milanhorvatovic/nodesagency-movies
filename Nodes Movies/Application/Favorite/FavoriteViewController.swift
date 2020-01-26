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

    private static let _cellIdentifier: String = "FavoriteListCellIdentifier"

    private let _viewModel: ViewModelType
    private var _disposeBag: DisposeBag

    @IBOutlet private weak var _tableView: UITableView!

    init(viewModel: ViewModelType) {
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

        self._tableView.register(CellType.self,
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
            .share(replay: 1,
                   scope: .forever)
        data
            .bind(to: self._tableView.rx.items(dataSource: dataSource))
            .disposed(by: self._disposeBag)
        if let backgroundView = self._tableView.backgroundView {
            data
                .map({ (data) -> CGFloat in
                    return data.isEmpty ? 1.0 : 0.0
                })
                .distinctUntilChanged()
                .bind(to: backgroundView.rx.alpha)
                .disposed(by: self._disposeBag)
        }
        self._tableView.rx.modelSelected(ViewModelType.ModelType.self)
            .subscribe(onNext: strongify(weak: self,
                                         closure: { (self, item) in
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
    }

}

extension FavoriteViewController {

    private func _presentSearch() {
        // TODO: show search
    }

    private func _didSelect(item: ViewModelType.ModelType) {
        // TODO: show detail
    }

}
