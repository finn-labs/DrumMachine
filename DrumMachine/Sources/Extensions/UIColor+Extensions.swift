//
//  UIColor+Extensions.swift
//  DrumMachine
//
//  Created by Markov, Vadym on 13/09/2018.
//  Copyright © 2018 FINN.no AS. All rights reserved.
//

import UIKit

extension UIColor {
    class var ice: UIColor {
        return UIColor(r: 241, g: 249, b: 255)!
    }

    class var milk: UIColor {
        return UIColor(r: 255, g: 255, b: 255)!
    }

    class var secondaryBlue: UIColor {
        return UIColor(r: 6, g: 190, b: 251)!
    }

    class var banana: UIColor {
        return .init(red: 235/255.0, green: 201/255.0, blue: 62/255.0, alpha: 1.0)
    }

    class var cherry: UIColor {
        return UIColor(r: 218, g: 36, b: 0)!
    }

    class var watermelon: UIColor {
        return UIColor(r: 255, g: 88, b: 68)!
    }

    class var pea: UIColor {
        return UIColor(r: 104, g: 226, b: 184)!
    }

    convenience init?(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
}
