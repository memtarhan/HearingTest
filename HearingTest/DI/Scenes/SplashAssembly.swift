//
//  SplashAssembly.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 23/04/2022.
//

import Swinject
import UIKit

class SplashAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SplashViewController.self) { resolver in
            let view = SplashViewController(nibName: "SplashViewController", bundle: nil)
            let factory = resolver.resolve(ViewControllerFactory.self)!

            view.factory = factory

            return view
        }
    }
}
