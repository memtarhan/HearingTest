//
//  UIView+.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 24/04/2022.
//

import UIKit

extension UIView {
    func makeCircle() {
        layer.cornerRadius = frame.height / 2
    }

    func addBorder(withColor color: UIColor? = UIColor.accentColor) {
        layer.borderColor = color?.cgColor
        layer.borderWidth = 0.2
    }
}
