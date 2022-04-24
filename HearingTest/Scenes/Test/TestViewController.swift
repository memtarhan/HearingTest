//
//  TestViewController.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 23/04/2022.
//

import Combine
import UIKit

class TestViewController: UIViewController {
    var viewModel: TestViewModel!

    // MARK: - Outlets

    @IBOutlet var tableView: UITableView!

    private let rowHeight: CGFloat = 96

    private var snapshot = NSDiffableDataSourceSnapshot<FrequencySection, Test.Frequency>()
    private lazy var dataSource = generatedDataSource

    private let models = [Test.Frequency(title: "Frequency 1", file: Test.Frequency.File(name: "50Hz", ext: "wav"), heard: false, playing: false),
                          Test.Frequency(title: "Frequency 2", file: Test.Frequency.File(name: "125Hz", ext: "wav"), heard: false, playing: false),
                          Test.Frequency(title: "Frequency 3", file: Test.Frequency.File(name: "250Hz", ext: "wav"), heard: false, playing: false),
                          Test.Frequency(title: "Frequency 4", file: Test.Frequency.File(name: "500Hz", ext: "wav"), heard: false, playing: false)]

    override func viewDidLoad() {
        super.viewDidLoad()

        let cell = UINib(nibName: FrequencyTableViewCell.nibIdentifier, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: FrequencyTableViewCell.cellReuseIdentifier)
        tableView.rowHeight = rowHeight
        tableView.dataSource = dataSource
        snapshot.appendSections([.frequency])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        snapshot.appendItems(models, toSection: .frequency)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    @IBAction func didTapContinue(_ sender: UIButton) {
    }

    @objc func didTapPlay(_ sender: UIButton) {
        let models = snapshot.itemIdentifiers

        // TODO: - Optimize this logic
        // Stop playing current audio
        var playingIndex: Int?

        if let index = models.firstIndex(where: { $0.playing }) {
            models[index].playing = false
//            if index == sender.tag { models[sender.tag].playing = false }
            playingIndex = index
        }

        // Play new one
        if playingIndex == sender.tag {
            models[sender.tag].playing = !models[sender.tag].playing

        } else {
            models[sender.tag].playing = true
        }

        snapshot.reconfigureItems(models)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private var generatedDataSource: FrequencyTableViewDiffableDataSource {
        FrequencyTableViewDiffableDataSource(tableView: tableView) { (tableView, indexPath, model) -> UITableViewCell? in

            guard let cell = tableView.dequeueReusableCell(withIdentifier: FrequencyTableViewCell.cellReuseIdentifier, for: indexPath) as? FrequencyTableViewCell
            else { return UITableViewCell() }

            cell.configure(model)
            cell.playPauseButton.tag = indexPath.row
            cell.playPauseButton.addTarget(self, action: #selector(self.didTapPlay(_:)), for: .touchUpInside)

            return cell
        }
    }
}
