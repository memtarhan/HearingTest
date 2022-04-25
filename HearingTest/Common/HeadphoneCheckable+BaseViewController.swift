//
//  HeadphoneCheckable.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 25/04/2022.
//

import AVFoundation
import Combine
import UIKit

/**
 A protocol for checking if device is connected to headphone
 */
protocol HeadphoneCheckable: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
    /**
        A boolean indicator for when view should be dismissed if headphones are connected. i.e StatusViewController
     */
    var shouldDismissWhenConnected: Bool { get set }

    func setupRouteChangeNotification()
    func checkIfHeadphoneConnected()
}

/**
 A base view controller that conforms to 'HeadphoneCheckable'
 */
class BaseViewController: UIViewController, HeadphoneCheckable {
    var factory: ViewControllerFactory!

    var cancellables: Set<AnyCancellable> = []
    @Published var headphonesConnected = CurrentValueSubject<Bool, Never>(true)

    var shouldDismissWhenConnected: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRouteChangeNotification()

        headphonesConnected.sink { [weak self] connected in
            if let self = self {
                print("Headphone: connected: \(connected)")
                if !connected { self.navigateToHeadphoneDisconnected() }
            }
        }
        .store(in: &cancellables)
    }

    func setupRouteChangeNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRouteChange),
                                               name: AVAudioSession.routeChangeNotification,
                                               object: AVAudioSession.sharedInstance())
    }

    @objc func handleRouteChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }

        switch reason {
        case .newDeviceAvailable: /// A new device became available (e.g. headphones have been plugged in).
            headphonesConnected.send(true)

        case .oldDeviceUnavailable: /// The old device became unavailable (e.g. headphones have been unplugged).
            headphonesConnected.send(false)
            print("Headphone: oldDeviceUnavailable: \(reason)")

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

    func navigateToHeadphoneDisconnected() {
        print("Headphone: navigateToHeadphoneDisconnected")

        let destination = factory.status

        if let sheet = destination.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 20
            sheet.prefersGrabberVisible = true
        }
        present(destination, animated: true)
    }
}
