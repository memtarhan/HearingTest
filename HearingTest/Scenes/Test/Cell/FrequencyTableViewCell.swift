//
//  FrequencyTableViewCell.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 24/04/2022.
//

import AVFoundation
import UIKit

class FrequencyTableViewCell: UITableViewCell {
    static let nibIdentifier = "FrequencyTableViewCell"
    static let cellReuseIdentifier = "Frequency"

    // MARK: - Outlets

    @IBOutlet var containerView: UIView!
    @IBOutlet var buttonContainerViews: [UIView]!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var hearButton: UIButton!
    @IBOutlet var titleLabel: UILabel!

    private var player: AVAudioPlayer?

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 20

        // TODO: - This can be easily moved to a custom UIView class
        buttonContainerViews.forEach {
            $0.makeCircle()
            $0.addBorder()
        }
    }

    func configure(_ model: Test.Frequency) {
        playPauseButton.setImage(getPlayPauseButtonImage(for: model.playing), for: .normal)
        hearButton.setImage(getHearButtonImage(for: model.heard), for: .normal)
        titleLabel.text = model.title

        setupPlayerIfNeeded(withFile: model.file)

        if model.playing { player?.play() }
        else { player?.stop() }
    }

    private func getPlayPauseButtonImage(for playing: Bool) -> UIImage? {
        playing ? UIImage(systemName: "pause.circle.fill") : UIImage(systemName: "play.circle.fill")
    }

    private func getHearButtonImage(for heard: Bool) -> UIImage? {
        heard ? UIImage(systemName: "ear.fill") : UIImage(systemName: "ear")
    }

    private func setupPlayerIfNeeded(withFile file: Test.Frequency.File) {
        if player == nil,
           let audioFilePath = Bundle.main.path(forResource: file.name, ofType: file.ext) {
            let audioFileUrl = NSURL.fileURL(withPath: audioFilePath)

            do {
                player = try AVAudioPlayer(contentsOf: audioFileUrl, fileTypeHint: nil)
                player?.numberOfLoops = 0
            } catch {
                print("AVAudioPlayer error = \(error)")
            }
        }
    }
}

enum FrequencySection: CaseIterable {
    case frequency
}

class FrequencyTableViewDiffableDataSource: UITableViewDiffableDataSource<FrequencySection, Test.Frequency> {}
