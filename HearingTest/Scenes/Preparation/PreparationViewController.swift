//
//  PreparationViewController.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 23/04/2022.
//

import AVFoundation
import Combine
import UIKit

class PreparationViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        checkIfHeadphoneConnected()
    }

    @IBAction func didTapGetStarted(_ sender: UIButton) {
        navigateToTest()
    }
}

// MARK: - Navigation

extension PreparationViewController {
    func navigateToTest() {
        let destination = factory.test
        destination.modalTransitionStyle = .crossDissolve
        destination.modalPresentationStyle = .fullScreen
        present(destination, animated: true)
    }
}
