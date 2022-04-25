//
//  ResultAssembly.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 23/04/2022.
//

import Swinject
import UIKit

class ResultAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ResultViewController.self) { resolver in
            let view = ResultViewController(nibName: "ResultViewController", bundle: nil)
            let factory = resolver.resolve(ViewControllerFactory.self)!

            view.factory = factory
            
            return view
        }
    }
}
