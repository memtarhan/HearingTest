//
//  SplashViewController.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 23/04/2022.
//

import UIKit

class SplashViewController: UIViewController {
    var factory: ViewControllerFactory!

    @IBOutlet var logoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut) {
            self.logoImageView.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.logoImageView.alpha = 0.0

        } completion: { _ in
            self.navigateToTest()
        }
    }

    // MARK: - Navigation

    func navigateToTest() {
        let destination = factory.test
        destination.modalTransitionStyle = .crossDissolve
        destination.modalPresentationStyle = .fullScreen
        present(destination, animated: true)
    }
}
