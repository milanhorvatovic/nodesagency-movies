//
//  UIViewController+Rx.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 27/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//


import UIKit

import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    
    public var viewWillAppearObservable: Observable<Bool> {
        return self.sentMessage(#selector(Base.viewWillAppear(_:)))
            .map({ (animated: [Any]) -> Bool in
                return animated.first as? Bool ?? false
            })
    }
    
}
