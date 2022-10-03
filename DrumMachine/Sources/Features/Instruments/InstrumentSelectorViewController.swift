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

//A big boy UIViewController class is made called InstrumentSelectorViewController, which will allow for switching between the different Instruments views

final class InstrumentSelectorViewController: UIViewController {
    weak var delegate: InstrumentSelectorViewControllerDelegate?
    private var selectedInstrument: Instrument
    //var selectedInstrument is declared, of type, Instrument
    private var instruments: [Instrument] = [.kick, .snare, .hats, .cat]
    //var instruments is declared, of type, array of Instruments
    //a UILabel class ccalled titleLabel is lazily declared
    
    private lazy var titleLabel: UILabel = {
        //a temporary UILabel called label is instanced within the function, that will later be returned to the parent class titleLabel
        let label = UILabel()
        //the UILabel property, .font is modified
        label.font = UIFont.boldSystemFont(ofSize: 36)
        //the property .translatesAutoresizingMaskIntoConstraints is disabled
        label.translatesAutoresizingMaskIntoConstraints = false
        //the textColor property is set to custom .milk
        label.textColor = .milk
        //the instance of UILabel is returned to it's parent class titleLabel
        return label
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        //a lazyily declared class segmentedControl, of typ UISegmentedControl is declared
        let segmentedControl = UISegmentedControl(items: self.instruments.map({ $0.rawValue }))
        //the .translatesAutoresizingMaskIntoConstraints attribute is disabled
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        //the .tintColor attribute is set to .white
        segmentedControl.tintColor = .white
        //the initialized segmentedControl function instance is returned to the segmentedControl class
        return segmentedControl
    }()

    // MARK: - Init

    //instrument is initialized, as a type of the Instrument enum
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
        segmentedControl.selectedSegmentIndex = instruments.firstIndex(where: { $0 == selectedInstrument}) ?? 0
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
//this takes a value of type UISegmentedControl and sets selectedInstrument to the currently selected instruments[] enumeration
    //then the view is changed to the selected instrument by changing the delegate of InstrumentSelectorViewController to true or something
    @objc private func handleSegmentedControlChange(_ sender: UISegmentedControl) {
        selectedInstrument = instruments[sender.selectedSegmentIndex]
        delegate?.instrumentSelectorViewController(self, didSelectInstrument: selectedInstrument)
    }
}
