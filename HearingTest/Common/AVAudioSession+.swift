//
//  AVAudioSession+.swift
//  HearingTest
//
//  Created by Mehmet Tarhan on 25/04/2022.
//

import AVFoundation

extension AVAudioSessionPortDescription {
    /**
        Returns true if specified output is any type of audio out device. This could be either Airpods, plugged-in headphone.
        This could return true for only plugged-in headphone if all conditions but 'portType == .headphones' is removed.
     */
    var isHeadphone: Bool {
        return portType == .bluetoothA2DP ||
            portType == .bluetoothHFP ||
            portType == .bluetoothLE ||
            portType == .headphones
    }
}
