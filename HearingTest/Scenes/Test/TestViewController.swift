//
//  TestViewController.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 23/04/2022.
//

import AVFoundation
import Combine
import UIKit

class TestViewController: UIViewController {
    var viewModel: TestViewModel!
    var factory: ViewControllerFactory!

    // MARK: - Outlets

    @IBOutlet var tableView: UITableView!

    private let rowHeight: CGFloat = 96

    private var snapshot = NSDiffableDataSourceSnapshot<FrequencySection, Test.Frequency>()
    private lazy var dataSource = generatedDataSource

    private var models: [Test.Frequency] = []

    private var generatedDataSource: FrequencyTableViewDiffableDataSource {
        FrequencyTableViewDiffableDataSource(tableView: tableView) { (tableView, indexPath, model) -> UITableViewCell? in

            guard let cell = tableView.dequeueReusableCell(withIdentifier: FrequencyTableViewCell.cellReuseIdentifier, for: indexPath) as? FrequencyTableViewCell
            else { return UITableViewCell() }

            cell.configure(model)

            cell.playPauseButton.tag = model.tag
            cell.playPauseButton.addTarget(self, action: #selector(self.didTapPlay(_:)), for: .touchUpInside)

            cell.hearButton.tag = model.tag
            cell.hearButton.addTarget(self, action: #selector(self.didTapHear(_:)), for: .touchUpInside)

            cell.delegate = self

            return cell
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNotifications()

        let cell = UINib(nibName: FrequencyTableViewCell.nibIdentifier, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: FrequencyTableViewCell.cellReuseIdentifier)
        tableView.rowHeight = rowHeight
        tableView.dataSource = dataSource
        snapshot.appendSections([.frequency])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        models = viewModel.models

        snapshot.appendItems(models, toSection: .frequency)
        dataSource.apply(snapshot, animatingDifferences: true)

        checkIfHeadphoneConnected()
    }

    func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRouteChange),
                                               name: AVAudioSession.routeChangeNotification,
                                               object: AVAudioSession.sharedInstance())
    }

    // MARK: - Actions

    @IBAction func didTapContinue(_ sender: UIButton) {
        navigateToHeadphoneDisconnected()
    }

    @objc func didTapPlay(_ sender: UIButton) {
        updatePlayingStatus(for: sender.tag)
    }

    @objc func didTapHear(_ sender: UIButton) {
        updateHearingStatus(for: sender.tag)
    }

    @objc func handleRouteChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }

        switch reason {
        case .oldDeviceUnavailable: /// The old device became unavailable (e.g. headphones have been unplugged).
            navigateToHeadphoneDisconnected()

        default: ()
        }
    }

    private func updatePlayingStatus(for tag: Int) {
        let models = snapshot.itemIdentifiers

        var playingIndex: Int?

        if let index = models.firstIndex(where: { $0.playing }) {
            playingIndex = index
        }

        if playingIndex == tag {
            models[tag].playing = !models[tag].playing

        } else {
            if let index = playingIndex {
                models[index].playing = false
            }
            models[tag].playing = true
        }

        snapshot.reconfigureItems(models)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func updateHearingStatus(for tag: Int) {
        let models = snapshot.itemIdentifiers
        models[tag].heard.toggle()
        snapshot.reconfigureItems(models)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func checkIfHeadphoneConnected() {
        let outputs = AVAudioSession.sharedInstance().currentRoute.outputs

        for output in outputs {
            if output.portType != AVAudioSession.Port.headphones {
                navigateToHeadphoneDisconnected()
            }
        }
    }
}

// MARK: - Navigation

extension TestViewController {
    func navigateToHeadphoneDisconnected() {
        let detailViewController = factory.status

        if let sheet = detailViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 20
            sheet.prefersGrabberVisible = true
        }
        present(detailViewController, animated: true, completion: nil)
    }
}

// MARK: - FrequencyTableViewCellDelegate

extension TestViewController: FrequencyTableViewCellDelegate {
    func frequencyDidFinishPlaying(model: Test.Frequency) {
        let models = snapshot.itemIdentifiers
        models[model.tag].playing = false
        snapshot.reconfigureItems(models)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
