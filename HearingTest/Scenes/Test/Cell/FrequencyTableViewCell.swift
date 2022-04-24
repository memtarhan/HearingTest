//
//  FrequencyTableViewCell.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 24/04/2022.
//

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
        titleLabel.text = model.fileName
    }

    private func getPlayPauseButtonImage(for playing: Bool) -> UIImage? {
        playing ? UIImage(systemName: "pause.circle.fill") : UIImage(systemName: "play.circle.fill")
    }

    private func getHearButtonImage(for heard: Bool) -> UIImage? {
        heard ? UIImage(systemName: "ear.fill") : UIImage(systemName: "ear")
    }
}

enum FrequencySection: CaseIterable {
    case frequency
}

class FrequencyTableViewDiffableDataSource: UITableViewDiffableDataSource<FrequencySection, Test.Frequency> {}

extension UIView {
    func makeCircle() {
        layer.cornerRadius = frame.height / 2
    }

    func addBorder(withColor color: UIColor? = UIColor.accentColor) {
        layer.borderColor = color?.cgColor
        layer.borderWidth = 0.2
    }
}
