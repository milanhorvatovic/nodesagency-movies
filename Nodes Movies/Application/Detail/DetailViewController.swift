//
//  DetailViewController.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 27/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import Foundation

import Strongify
import RxSwift
import RxSwiftExt
import RxOptional
import RxCocoa
import Kingfisher

final class DetailViewController: UIViewController {

    typealias ViewModelType = DetailViewModel
    typealias ContextType = Application.Context

    private let _context: ContextType
    private let _viewModel: ViewModelType
    private var _disposeBag: DisposeBag

    @IBOutlet private var posterImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var voteAverageLabel: UILabel!
    @IBOutlet private var voteCountLabel: UILabel!
    @IBOutlet private var releasedLabel: UILabel!
    @IBOutlet private var favoriteSwitch: UISwitch!
    @IBOutlet private var overview: UITextView!

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

        self.navigationItem.title = "Search movies"

        self._disposeBag = DisposeBag()

        self.rx.viewWillAppearObservable
            .map({ (_) -> Void in
                return ()
            })
            .bind(to: self._viewModel.fetchAction)
            .disposed(by: self._disposeBag)
        let data = self._viewModel.data
            .share(replay: 1,
                   scope: .forever)

        data
            .filterNil()
            .subscribe(onNext: strongify(weak: self, closure: { (self, model) in
                self.posterImageView.kf.setImage(with: Resources.Helper.imageUrl(with: model))
            }))
            .disposed(by: self._disposeBag)
        data
            .map({ (model) -> String? in
                return model?.title.localized
            })
            .subscribe(onNext: strongify(weak: self,
                                         closure: { (self, value) in
                                            self.title = value
            }))
            .disposed(by: self._disposeBag)
        data
            .map({ (model) -> String? in
                return model?.title.localized
            })
            .bind(to: self.titleLabel.rx.text)
            .disposed(by: self._disposeBag)
        data
            .map({ (model) -> String? in
                guard let value = model?.vote.average else {
                    return nil
                }
                return "\(value)"
            })
            .bind(to: self.voteAverageLabel.rx.text)
            .disposed(by: self._disposeBag)
        data
            .map({ (model) -> String? in
                guard let value = model?.vote.count else {
                    return nil
                }
                return "\(value)"
            })
            .bind(to: self.voteCountLabel.rx.text)
            .disposed(by: self._disposeBag)
        data
            .map({ (model) -> String? in
                return model?.releaseDate
            })
            .bind(to: self.releasedLabel.rx.text)
            .disposed(by: self._disposeBag)
        data
            .map({ (model) -> String? in
                return model?.overview
            })
            .bind(to: self.overview.rx.text)
            .disposed(by: self._disposeBag)

        self._viewModel.isFavorited
            .bind(to: self.favoriteSwitch.rx.isOn)
            .disposed(by: self._disposeBag)
        self.favoriteSwitch.rx.isOn
            .filter({ (value) -> Bool in
                return value == true
            })
            .map({ (_) -> Void in
                return ()
            })
            .bind(to: self._viewModel.favoriteAction)
            .disposed(by: self._disposeBag)
        self.favoriteSwitch.rx.isOn
            .filter({ (value) -> Bool in
                return value == false
            })
            .map({ (_) -> Void in
                return ()
            })
            .bind(to: self._viewModel.unfavoriteAction)
            .disposed(by: self._disposeBag)
    }

}

extension SearchViewController {

    private func _dismiss() {
        self.dismiss(animated: true,
                     completion: nil)
    }

    private func _didSelect(item: ViewModelType.ModelType) {
        // TODO: show detail
    }

}
