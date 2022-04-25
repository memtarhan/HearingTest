//
//  StatusAssembly.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 25/04/2022.
//

import Swinject
import UIKit

class StatusAssembly: Assembly {
    func assemble(container: Container) {
        container.register(StatusViewController.self) { _ in
            let view = StatusViewController(nibName: "StatusViewController", bundle: nil)

            return view
        }
    }
}
