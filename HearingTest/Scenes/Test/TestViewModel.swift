//
//  TestViewModel.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 23/04/2022.
//

import Combine
import Foundation

class TestViewModel {
    private var cancellables: Set<AnyCancellable> = []

    let models = CurrentValueSubject<[Test.Frequency], Never>([Test.Frequency.sample])
    let updatedModels = CurrentValueSubject<[Test.Frequency], Never>([Test.Frequency.sample])
    let result = CurrentValueSubject<Test.Result, Never>(.impaired)

    init() {
        models.send([Test.Frequency(title: "Frequency 1", file: Test.Frequency.File(name: "50Hz", ext: "wav"), heard: false, playing: false, tag: 0),
                     Test.Frequency(title: "Frequency 2", file: Test.Frequency.File(name: "125Hz", ext: "wav"), heard: false, playing: false, tag: 1),
                     Test.Frequency(title: "Frequency 3", file: Test.Frequency.File(name: "250Hz", ext: "wav"), heard: false, playing: false, tag: 2),
                     Test.Frequency(title: "Frequency 4", file: Test.Frequency.File(name: "500Hz", ext: "wav"), heard: false, playing: false, tag: 3)])

        updatedModels.sink { updatedModels in
            let heard = updatedModels.filter { $0.heard }
            switch heard.count {
            case 0:
                self.result.send(.impaired)
            case updatedModels.count:
                self.result.send(.excellent)
            default:
                self.result.send(.limited)
            }
        }
        .store(in: &cancellables)
    }
}
