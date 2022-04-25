//
//  TestViewModel.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 23/04/2022.
//

import Foundation

class TestViewModel {
    let models = [Test.Frequency(title: "Frequency 1", file: Test.Frequency.File(name: "50Hz", ext: "wav"), heard: false, playing: false, tag: 0),
                  Test.Frequency(title: "Frequency 2", file: Test.Frequency.File(name: "125Hz", ext: "wav"), heard: false, playing: false, tag: 1),
                  Test.Frequency(title: "Frequency 3", file: Test.Frequency.File(name: "250Hz", ext: "wav"), heard: false, playing: false, tag: 2),
                  Test.Frequency(title: "Frequency 4", file: Test.Frequency.File(name: "500Hz", ext: "wav"), heard: false, playing: false, tag: 3)]
}
