//
//  PreparationAssembly.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 23/04/2022.
//

import Swinject
import UIKit

class PreparationAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PreparationViewController.self) { _ in
            let view = PreparationViewController(nibName: "PreparationViewController", bundle: nil)

            return view
        }
    }
}
