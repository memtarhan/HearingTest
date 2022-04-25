//
//  StatusViewController.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 25/04/2022.
//

import AVFoundation
import UIKit

class StatusViewController: UIViewController {
    @IBOutlet var imageContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNotifications()

        imageContainerView.makeCircle()
        imageContainerView.addBorder()

        isModalInPresentation = true
    }

    func setupNotifications() {
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
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }

        default: ()
        }
    }
}
