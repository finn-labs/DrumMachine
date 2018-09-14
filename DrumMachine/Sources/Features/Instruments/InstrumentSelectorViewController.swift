//
//  InstrumentSelectorViewController.swift
//  FINN
//
//  Created by Markov, Vadym on 06/09/2018.
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

protocol InstrumentSelectorViewControllerDelegate: AnyObject {
    func instrumentSelectorViewController(
        _ viewController: InstrumentSelectorViewController,
        didSelectInstrument instrument: Instrument
    )
}

final class InstrumentSelectorViewController: UIViewController {
    weak var delegate: InstrumentSelectorViewControllerDelegate?
    private var selectedInstrument: Instrument
    private var instruments: [Instrument] = [.kick, .snare, .hats, .cat]

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .milk
        return label
    }()

    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: self.instruments.map({ $0.rawValue }))
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.tintColor = .white
        return segmentedControl
    }()

    // MARK: - Init

    init(instrument: Instrument) {
        self.selectedInstrument = instrument
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(titleLabel)
        view.addSubview(segmentedControl)
        setupConstraints()

        titleLabel.text = "Instruments"
        segmentedControl.selectedSegmentIndex = instruments.index(where: { $0 == selectedInstrument}) ?? 0
        segmentedControl.addTarget(self, action: #selector(handleSegmentedControlChange(_:)), for: .valueChanged)
    }

    // MARK: - Layout

    private func setupConstraints() {
        let spacing: CGFloat = 16

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: spacing),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            segmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            segmentedControl.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])
    }

    // MARK: - Actions

    @objc private func handleSegmentedControlChange(_ sender: UISegmentedControl) {
        selectedInstrument = instruments[sender.selectedSegmentIndex]
        delegate?.instrumentSelectorViewController(self, didSelectInstrument: selectedInstrument)
    }
}
