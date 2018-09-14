//
//  DrumPadPlayer.swift
//  FINN
//
//  Created by Markov, Vadym on 06/09/2018.
//  Copyright © 2018 FINN.no. All rights reserved.
//

import AVFoundation

final class DrumPadPlayer {
    private let audioSession: AVAudioSession
    private let bundle: Bundle

    // MARK: - Init

    init(bundle: Bundle = .main, audioSession: AVAudioSession = .sharedInstance()) {
        self.bundle = bundle
        self.audioSession = audioSession
        try? audioSession.setCategory(AVAudioSessionCategoryPlayback)
        try? audioSession.setActive(true)
    }

    // MARK: - Player

    func play(instrument: Instrument) {
        guard let sound = makeSound(for: instrument) else {
            return
        }
        AudioServicesPlaySystemSound(sound)
    }

    private func makeSound(for instrument: Instrument) -> SystemSoundID? {
        let resource = instrument.rawValue.lowercased()

        guard let soundURL = Bundle.main.url(forResource: resource, withExtension: "wav") else {
            return nil
        }

        var sound: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &sound)
        return sound
    }
}
