//
//  UITableView.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 27/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import UIKit

class TableView: UITableView {

    @IBOutlet private(set) weak var _backgroundView: UIView? {
        didSet {
            self.backgroundView = self._backgroundView
        }
    }

}
