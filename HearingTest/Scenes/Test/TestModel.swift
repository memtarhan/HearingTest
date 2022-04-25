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
        let tag: Int

        init(title: String, file: File, heard: Bool, playing: Bool, tag: Int) {
            self.title = title
            self.file = file
            self.heard = heard
            self.playing = playing
            self.tag = tag
        }

        struct File: Hashable, Equatable {
            let name: String
            let ext: String

            static func == (lhs: File, rhs: File) -> Bool {
                return (lhs.name == rhs.name) && (lhs.ext == lhs.ext)
            }
        }

        static let sample = Test.Frequency(title: "Sample", file: Test.Frequency.File(name: "", ext: ""), heard: false, playing: false, tag: -1)
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
