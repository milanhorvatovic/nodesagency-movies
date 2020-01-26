//
//  ObservablType+Action.swift
//  Nodes Movies
//
//  Created by Milan Horvatovic on 26/01/2020.
//  Copyright © 2020 Milan Horvatovic. All rights reserved.
//

import Foundation

import RxSwift
import Action

public extension ObservableType {

    func bind<ValueType>(to action: Action<ValueType, ValueType>) -> Disposable where ValueType == Element {
        return self.bind(to: action.inputs)
    }

    func bind<ValueType, OutputValueType>(to action: Action<ValueType, OutputValueType>) -> Disposable where ValueType == Element {
        return self.bind(to: action.inputs)
    }

    func bind<ValueType, InputValueType, OutputValueType>(to action: Action<InputValueType, OutputValueType>,
                                                          inputTransform: @escaping (ValueType) -> (InputValueType)) -> Disposable where ValueType == Element {
        return self
            .map({ (input: ValueType) -> InputValueType in
                return inputTransform(input)
            })
            .bind(to: action.inputs)
    }

}
