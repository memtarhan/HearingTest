//
//  TestViewController.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 23/04/2022.
//

import AVFoundation
import Combine
import UIKit

class TestViewController: BaseViewController {
    var viewModel: TestViewModel!

    // MARK: - Outlets

    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    private let rowHeight: CGFloat = 96

    private var snapshot = NSDiffableDataSourceSnapshot<FrequencySection, Test.Frequency>()
    private lazy var dataSource = generatedDataSource

    private var models: [Test.Frequency] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let cell = UINib(nibName: FrequencyTableViewCell.nibIdentifier, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: FrequencyTableViewCell.cellReuseIdentifier)
        tableView.rowHeight = rowHeight
        tableView.dataSource = dataSource
        snapshot.appendSections([.frequency])
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
}

// MARK: - Navigation

extension TestViewController {
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
