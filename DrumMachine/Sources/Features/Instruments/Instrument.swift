//
//  Instrument.swift
//  FINN
//
//  Created by Markov, Vadym on 06/09/2018.
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit
import AudioToolbox

enum Instrument: String {
    case kick = "Kick"
    case snare = "Snare"
    case hats = "Hi-Hats"
    case cat = "PuseFINN"

    var color: UIColor {
        switch self {
        case .kick:
            return .pea
        case .snare:
            return .banana
        case .hats:
            return .watermelon
        case .cat:
            return .secondaryBlue
        }
    }
}
