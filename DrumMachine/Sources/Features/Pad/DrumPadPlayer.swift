//
//  DrumPadPlayer.swift
//  FINN
//
//  Created by Markov, Vadym on 06/09/2018.
//  Copyright © 2018 FINN.no. All rights reserved.
//

import AVFoundation

//a class initializer for the drum pads are made
final class DrumPadPlayer {
    //AVAudio Session and Bundle objects are instanced privately as let
    private let audioSession: AVAudioSession
    private let bundle: Bundle

    // MARK: - Init

    
    //an initializer initializes some shit
    init(bundle: Bundle = .main, audioSession: AVAudioSession = .sharedInstance()) {
        self.bundle = bundle
        self.audioSession = audioSession
        try? audioSession.setCategory(AVAudioSession.Category.playback)
        try? audioSession.setActive(true)
    }

    // MARK: - Player

    
    //a fucntion play takes the currently selected instrument as input
    func play(instrument: Instrument) {
        //local constant sound is assigned the function makeSound(for: instrument)
        guard let sound = makeSound(for: instrument) else {
            //an else statemnt exits the function if unsuccesful
            return
        }
        //the local constant sound is sent as input into AudioServicesPlaySystemSound()
        AudioServicesPlaySystemSound(sound)
    }

    
    //the makeSound(for instrument) function takes Instrument as input and returns SystemSoundID? as an optional
    private func makeSound(for instrument: Instrument) -> SystemSoundID? {
        //a local constant holds the raw lowercased value of the instrument input
        let resource = instrument.rawValue.lowercased()
        //resource is passed as the Bundle.main.url(forResource: parameter and the withExtensin: parameter is set to the string literal "wav"
        guard let soundURL = Bundle.main.url(forResource: resource, withExtension: "wav") else {
            //otherwise nil is returned
            return nil
        }

        //the variable sound is initialized at 0
        var sound: SystemSoundID = 0
        //the function AudioServicesCreateSystemSoundID fucntion is called, and soundURL is passed as CFURL
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &sound)
        //the sound is finally returned
        return sound
        
    }
}
