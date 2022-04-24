//
//  TestModel.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 23/04/2022.
//

import Foundation

struct Test {
    class Frequency {
        let fileName: String
        var heard: Bool
        var playing: Bool
        
        init(fileName: String, heard: Bool, playing: Bool) {
            self.fileName = fileName
            self.heard = heard
            self.playing = playing
        }
    }
}

/// - to confirm UITableViewDiffableDataSource
extension Test.Frequency: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(fileName)
    }

    static func == (lhs: Test.Frequency, rhs: Test.Frequency) -> Bool {
        return lhs.fileName == rhs.fileName
    }
}
