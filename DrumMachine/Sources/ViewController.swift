//
//  ViewController.swift
//  DrumMachine
//
//  Created by Markov, Vadym on 06/09/2018.
//  Copyright © 2018 FINN.no AS. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let viewController = DrumsViewController()
        present(viewController, animated: true, completion: nil)
    }
}

