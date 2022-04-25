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
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    private let rowHeight: CGFloat = 96

    private var snapshot = NSDiffableDataSourceSnapshot<FrequencySection, Test.Frequency>()
    private lazy var dataSource = generatedDataSource

    private var models: [Test.Frequency] = []

    // MARK: - Functional Reactive [Combine]

    private var cancellables: Set<AnyCancellable> = []
    @Published var headphonesConnected = CurrentValueSubject<Bool, Never>(true)

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRouteChange),
                                               name: AVAudioSession.routeChangeNotification,
                                               object: AVAudioSession.sharedInstance())

        let cell = UINib(nibName: FrequencyTableViewCell.nibIdentifier, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: FrequencyTableViewCell.cellReuseIdentifier)
        tableView.rowHeight = rowHeight
        tableView.dataSource = dataSource
        snapshot.appendSections([.frequency])

        headphonesConnected.sink { connected in
            if !connected { self.navigateToHeadphoneDisconnected() }
        }
        .store(in: &cancellables)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.models.sink { [weak self] models in
            if let self = self {
                self.models = models
                self.snapshot.appendItems(self.models, toSection: .frequency)
                self.dataSource.apply(self.snapshot, animatingDifferences: true)
                self.activityIndicator.stopAnimating()
            }
        }
        .store(in: &cancellables)

        checkIfHeadphoneConnected()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let models = snapshot.itemIdentifiers
        models.forEach { $0.playing = false }
        snapshot.reconfigureItems(models)
        dataSource.apply(snapshot, animatingDifferences: true)
        viewModel.updatedModels.send(models)
    }

    // MARK: - Actions

    @IBAction func didTapContinue(_ sender: UIButton) {
        let result = viewModel.result.value
        navigateToResult(withResult: result)
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
            headphonesConnected.send(false)

        default: ()
        }
    }

    private func updatePlayingStatus(for tag: Int) {
        let models = snapshot.itemIdentifiers

        let playingItemIndex: Int? = models.firstIndex(where: { $0.playing })

        if playingItemIndex == tag {
            models[tag].playing = !models[tag].playing

        } else {
            if let index = playingItemIndex {
                models[index].playing = false
            }
            models[tag].playing = true
        }

        snapshot.reconfigureItems(models)
        dataSource.apply(snapshot, animatingDifferences: true)
        viewModel.updatedModels.send(models)
    }

    private func updateHearingStatus(for tag: Int) {
        let models = snapshot.itemIdentifiers
        models[tag].heard.toggle()
        snapshot.reconfigureItems(models)
        dataSource.apply(snapshot, animatingDifferences: true)
        viewModel.updatedModels.send(models)
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

extension TestViewController {
    func navigateToHeadphoneDisconnected() {
        let destination = factory.status

        if let sheet = destination.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 20
            sheet.prefersGrabberVisible = true
        }
        present(destination, animated: true)
    }

    func navigateToResult(withResult result: Test.Result) {
        let destination = factory.result
        destination.result.send(result)

        destination.modalTransitionStyle = .crossDissolve
        destination.modalPresentationStyle = .fullScreen

        present(destination, animated: true)
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

// MARK: - TableView & DataSource

extension TestViewController {
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
}
