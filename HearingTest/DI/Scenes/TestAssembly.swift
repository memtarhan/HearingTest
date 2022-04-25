//
//  TestAssembly.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 23/04/2022.
//

import Swinject
import UIKit

class TestAssembly: Assembly {
    func assemble(container: Container) {
        container.register(TestViewController.self) { resolver in
            let view = TestViewController(nibName: "TestViewController", bundle: nil)
            let viewModel = resolver.resolve(TestViewModel.self)!
            let factory = resolver.resolve(ViewControllerFactory.self)!

            view.viewModel = viewModel
            view.factory = factory

            return view
        }

        container.register(TestViewModel.self) { _ in
            TestViewModel()
        }
    }
}
