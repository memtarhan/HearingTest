//
//  ResultViewController.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 23/04/2022.
//

import Combine
import UIKit

class ResultViewController: UIViewController {
    var factory: ViewControllerFactory!

    // MARK: - Outlets

    @IBOutlet var resultLabel: UILabel!

    // MARK: - Functional Reactive [Combine]

    private var cancellables: Set<AnyCancellable> = []
    let result = CurrentValueSubject<Test.Result, Never>(.impaired)

    override func viewDidLoad() {
        super.viewDidLoad()

        result.sink { [weak self] value in
            if let self = self {
                self.resultLabel.text = value.message
            }
        }
        .store(in: &cancellables)
    }
    
    @IBAction func didTapFinish(_ sender: UIButton) {
        navigateToSplash()
    }
    
}

// MARK: - Navigation

extension ResultViewController {
    func navigateToSplash() {
        let destination = factory.splash
        destination.modalTransitionStyle = .crossDissolve
        destination.modalPresentationStyle = .fullScreen
        present(destination, animated: true)
    }
}
