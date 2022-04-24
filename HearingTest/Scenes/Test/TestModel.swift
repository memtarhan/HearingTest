//
//  TestModel.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 23/04/2022.
//

import Foundation

struct Test {
    class Frequency {
        let title: String
        let file: File
        var heard: Bool
        var playing: Bool

        init(title: String, file: File, heard: Bool, playing: Bool) {
            self.title = title
            self.file = file
            self.heard = heard
            self.playing = playing
        }

        struct File: Hashable, Equatable {
            let name: String
            let ext: String

            static func == (lhs: File, rhs: File) -> Bool {
                return (lhs.name == rhs.name) && (lhs.ext == lhs.ext)
            }
        }
    }
}

/// - to confirm UITableViewDiffableDataSource
extension Test.Frequency: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(file)
    }

    static func == (lhs: Test.Frequency, rhs: Test.Frequency) -> Bool {
        return lhs.file == rhs.file
    }
}
