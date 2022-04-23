//
//  ViewControllerFactory.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 23/04/2022.
//

import Foundation
import Swinject

protocol ViewControllerFactory: AnyObject {
    var preparation: PreparationViewController { get }
    var result: ResultViewController { get }
    var test: TestViewController { get }
}

class ViewControllerFactoryImpl: ViewControllerFactory {
    private let assembler: Assembler

    init(assembler: Assembler) {
        self.assembler = assembler
    }

    var preparation: PreparationViewController { assembler.resolver.resolve(PreparationViewController.self)! }
    var result: ResultViewController { assembler.resolver.resolve(ResultViewController.self)! }
    var test: TestViewController { assembler.resolver.resolve(TestViewController.self)! }
}
