//
//  FavoriteListCell.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 26/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import UIKit

final class FavoriteListCell: UITableViewCell {

    typealias ModelType = Model.Service.Movie.Detail

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var voteAverageLabel: UILabel!
    @IBOutlet private weak var voteCountLabel: UILabel!

}

// MARK: Configure
extension FavoriteListCell {

    func configure(with model: ModelType) {
        self.titleLabel.text = model.title.localized
        self.voteAverageLabel.text = "\(round(model.vote.average))"
        self.voteCountLabel.text = "\(model.vote.count)"
    }

}
