//
//  SearchListCell.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 27/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import UIKit

import Kingfisher

final class SearchListCell: UITableViewCell {

    typealias ModelType = Model.Service.Movie.Result

    @IBOutlet private var posterImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var voteAverageLabel: UILabel!
    @IBOutlet private var voteCountLabel: UILabel!

}

// MARK: Configure
extension SearchListCell {

    func configure(with model: ModelType) {
        self.posterImageView.kf.setImage(with: Resources.Helper.imageUrl(with: model))
        self.titleLabel.text = model.title.localized
        self.voteAverageLabel.text = "\(round(model.vote.average))"
        self.voteCountLabel.text = "\(model.vote.count)"
    }

}
