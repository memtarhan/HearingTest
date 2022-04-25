//
//  StatusViewController.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 25/04/2022.
//

import AVFoundation
import Combine
import UIKit

// TODO: This view controller also can be a subclass of BaseViewController
class StatusViewController: UIViewController {
    @IBOutlet var imageContainerView: UIView!

    private var cancellables: Set<AnyCancellable> = []
    @Published var headphonesConnected = CurrentValueSubject<Bool, Never>(false)

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRouteChange),
                                               name: AVAudioSession.routeChangeNotification,
                                               object: AVAudioSession.sharedInstance())

        imageContainerView.makeCircle()
        imageContainerView.addBorder()

        isModalInPresentation = true

        headphonesConnected.sink { connected in
            if connected { self.dismiss(animated: true) }
        }
        .store(in: &cancellables)
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

        default: ()
        }
    }
}
