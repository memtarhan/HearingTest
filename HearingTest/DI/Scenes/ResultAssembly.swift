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
        container.register(ResultViewController.self) { _ in
            let view = ResultViewController(nibName: "ResultViewController", bundle: nil)

            return view
        }
    }
}
