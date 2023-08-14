//
//  DrumsViewController.swift
//  FINN
//
//  Created by Markov, Vadym on 06/09/2018.
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

protocol DrumsViewControllerDelegate: AnyObject {
    func drumsViewControllerDidTapClose(_ controller: DrumsViewController)
}

final class DrumsViewController: UIViewController {
    weak var delegate: DrumsViewControllerDelegate?
    private var instrument: Instrument = .kick

    private lazy var selectorViewController = InstrumentSelectorViewController(instrument: self.instrument)
    private lazy var padViewController = DrumPadViewController(instrument: self.instrument)
    private lazy var footerView: DrumsFooterView = {
        let view = DrumsFooterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftButton.setTitle("Reset", for: .normal)
        view.rightButton.setTitle("Close", for: .normal)
        return view
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        add(childController: selectorViewController)
        add(childController: padViewController)
        view.addSubview(footerView)
        setupConstraints()

        selectorViewController.delegate = self
        footerView.leftButton.addTarget(self, action: #selector(resetButtonTapped(_:)), for: .touchUpInside)
        footerView.rightButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
    }

    // MARK: - Layout

    private func setupConstraints() {
        let selectorView = selectorViewController.view!
        let padView = padViewController.view!

        selectorView.translatesAutoresizingMaskIntoConstraints = false
        padView.translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 11.0, *) {
            selectorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            selectorView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }

        NSLayoutConstraint.activate([
            selectorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectorView.heightAnchor.constraint(equalToConstant: 100),

            padView.topAnchor.constraint(equalTo: selectorView.bottomAnchor, constant: 30),
            padView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            padView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            padView.bottomAnchor.constraint(equalTo: footerView.topAnchor),

            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        if #available(iOS 11.0, *) {
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    }

    // MARK: - Actions

    @objc private func resetButtonTapped(_ sender: UIButton) {
        padViewController.reset()
    }

    @objc private func closeButtonTapped(_ sender: UIButton) {
        delegate?.drumsViewControllerDidTapClose(self)
    }
}

// MARK: - InstrumentSelectorViewControllerDelegate

extension DrumsViewController: InstrumentSelectorViewControllerDelegate {
    func instrumentSelectorViewController(_ viewController: InstrumentSelectorViewController,
                                          didSelectInstrument instrument: Instrument) {
        self.instrument = instrument
        padViewController.instrument = instrument
    }
}

// MARK: - Private extensions

private extension UIViewController {
    func add(childController: UIViewController) {
        childController.willMove(toParent: self)
        addChild(_:(childController))
        view.addSubview(childController.view)
        childController.didMove(toParent: self)
    }
}
