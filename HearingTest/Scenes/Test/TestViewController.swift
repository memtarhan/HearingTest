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

    private let models = [Test.Frequency(title: "Frequency 1", file: Test.Frequency.File(name: "50Hz", ext: "wav"), heard: false, playing: false, tag: 0),
                          Test.Frequency(title: "Frequency 2", file: Test.Frequency.File(name: "125Hz", ext: "wav"), heard: false, playing: false, tag: 1),
                          Test.Frequency(title: "Frequency 3", file: Test.Frequency.File(name: "250Hz", ext: "wav"), heard: false, playing: false, tag: 2),
                          Test.Frequency(title: "Frequency 4", file: Test.Frequency.File(name: "500Hz", ext: "wav"), heard: false, playing: false, tag: 3)]

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

        var playingIndex: Int?

        if let index = models.firstIndex(where: { $0.tag == sender.tag }) {
            playingIndex = index
        }

        if playingIndex == sender.tag {
            models[sender.tag].playing = !models[sender.tag].playing

        } else {
            if let index = playingIndex {
                models[index].playing = false
            }
            models[sender.tag].playing = true
        }

        snapshot.reconfigureItems(models)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    @objc func didTapHear(_ sender: UIButton) {
        let models = snapshot.itemIdentifiers
        models[sender.tag].heard.toggle()
        snapshot.reconfigureItems(models)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

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

// MARK: - FrequencyTableViewCellDelegate

extension TestViewController: FrequencyTableViewCellDelegate {
    func frequencyDidFinishPlaying(model: Test.Frequency) {
        let models = snapshot.itemIdentifiers
        models[model.tag].playing = false
        snapshot.reconfigureItems(models)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
