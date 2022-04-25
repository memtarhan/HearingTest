//
//  PreparationViewController.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 23/04/2022.
//

import AVFoundation
import Combine
import UIKit

class PreparationViewController: UIViewController {
    var factory: ViewControllerFactory!

    // MARK: - Functional Reactive [Combine]

    private var cancellables: Set<AnyCancellable> = []
    @Published var headphonesConnected = CurrentValueSubject<Bool, Never>(true)

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRouteChange),
                                               name: AVAudioSession.routeChangeNotification,
                                               object: AVAudioSession.sharedInstance())

        headphonesConnected.sink { connected in
            if !connected { self.navigateToHeadphoneDisconnected() }
        }
        .store(in: &cancellables)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        checkIfHeadphoneConnected()
    }

    @IBAction func didTapGetStarted(_ sender: UIButton) {
        navigateToTest()
    }

    @objc func handleRouteChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }

        switch reason {
        case .oldDeviceUnavailable: /// The old device became unavailable (e.g. headphones have been unplugged).
            headphonesConnected.send(false)

        default: ()
        }
    }

    func checkIfHeadphoneConnected() {
        let outputs = AVAudioSession.sharedInstance().currentRoute.outputs

        var connected = false
        for output in outputs {
            if output.isHeadphone {
                connected = true
                break
            }
        }

        headphonesConnected.send(connected)
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

    func navigateToHeadphoneDisconnected() {
        let destination = factory.status

        if let sheet = destination.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 20
            sheet.prefersGrabberVisible = true
        }
        present(destination, animated: true)
    }
}
