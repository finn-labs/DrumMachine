//
//  DrumPadViewController.swift
//  FINN
//
//  Created by Markov, Vadym on 06/09/2018.
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

final class DrumPadViewController: UIViewController {
    private let padSpacing: CGFloat = 16
    private let cellSpacing: CGFloat = 4
    private let numberOfPads = 16
    private var currentPad = 0
    private var timer: Timer?
    private var beatsPerMinute: Float = 120

    private lazy var player = DrumPadPlayer()
    private lazy var compositions: [Instrument: [Bool]] = self.makeEmptyCompositions()

    var instrument: Instrument {
        didSet {
            collectionView.reloadData()
        }
    }

    private var timeInterval: Double {
        return (60.0 / Double(beatsPerMinute)) / 4
    }

    private lazy var collectionView: UICollectionView = makeCollectionView()
    private lazy var bpmSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 80
        slider.maximumValue = 160
        slider.tintColor = .pea
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()

    // MARK: - Init

    init(instrument: Instrument) {
        self.instrument = instrument
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(collectionView)
        view.addSubview(bpmSlider)
        setupConstraints()

        bpmSlider.setValue(beatsPerMinute, animated: false)
        bpmSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        collectionView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startLoop()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        endLoop()
    }

    // MARK: - Composition

    func reset() {
        endLoop()
        currentPad = 0
        compositions = makeEmptyCompositions()
        collectionView.reloadData()
        startLoop()
    }

    private func makeEmptyCompositions() -> [Instrument: [Bool]] {
        return [
            .kick: Array(repeating: false, count: self.numberOfPads),
            .snare: Array(repeating: false, count: self.numberOfPads),
            .hats: Array(repeating: false, count: self.numberOfPads),
            .cat: Array(repeating: false, count: self.numberOfPads)
        ]
    }

    @objc private func sliderValueChanged(_ slider: UISlider) {
        beatsPerMinute = slider.value
        endLoop()
        startLoop()
    }

    // MARK: - Layout

    private func setupConstraints() {
        let spacing: CGFloat = 16

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bpmSlider.topAnchor, constant: -spacing * 2),

            bpmSlider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -spacing * 3),
            bpmSlider.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: spacing),
            bpmSlider.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -spacing)
        ])
    }

    // MARK: - Timer

    private func startLoop() {
        timer = Timer.scheduledTimer(
            timeInterval: timeInterval,
            target: self,
            selector: #selector(update),
            userInfo: nil,
            repeats: true
        )
    }

    private func endLoop() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func update() {
        currentPad += 1

        if currentPad == numberOfPads {
            currentPad = 0
        }

        let nextCell = collectionView.cellForItem(
            at: IndexPath(item: currentPad, section: 0),
            type: DrumPadCollectionViewCell.self
        )

        nextCell?.flash(withDuration: timeInterval)

        for (_, instrumentComposition) in compositions.enumerated() {
            if instrumentComposition.value[currentPad] {
                player.play(instrument: instrumentComposition.key)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension DrumPadViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfPads
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(type: DrumPadCollectionViewCell.self, indexPath: indexPath)
        cell.contentView.backgroundColor = instrument.color
        cell.updateOverlayVisibility(isVisible: compositions[instrument]?[indexPath.item] ?? false)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension DrumPadViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pad = indexPath.item
        let currentValue = compositions[instrument]?[pad] ?? false
        let newValue = !currentValue
        compositions[instrument]?[pad] = newValue

        let cell = collectionView.cellForItem(
            at: IndexPath(item: pad, section: 0),
            type: DrumPadCollectionViewCell.self
        )

        cell?.updateOverlayVisibility(isVisible: newValue)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let minParentSideSize = min(collectionView.frame.width, collectionView.frame.height)
        let width = calculateItemMeasurement(for: collectionView.frame.width)
        let height = calculateItemMeasurement(for: minParentSideSize)
        return CGSize(width: width, height: height)
    }

    private func calculateItemMeasurement(for parentSideSize: CGFloat) -> CGFloat {
        let itemsPerRow: CGFloat = 4
        return (parentSideSize - cellSpacing * (itemsPerRow - 1) - padSpacing * 2) / itemsPerRow
    }
}

// MARK: - Subviews factory

private extension DrumPadViewController {
    func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.register(type: DrumPadCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }

    func makeCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(
            top: padSpacing,
            left: padSpacing,
            bottom: padSpacing,
            right: padSpacing
        )
        return layout
    }
}

// MARK: - Private extensions

private extension UICollectionView {
    func register<T: UICollectionViewCell>(type: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
    }

    func dequeue<T: UICollectionViewCell>(type: T.Type, indexPath: IndexPath) -> T {
        if let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T {
            return cell
        } else {
            assertionFailure("Incorrect type of cell")
            return T.init()
        }
    }

    func cellForItem<T: UICollectionViewCell>(at indexPath: IndexPath, type: T.Type) -> T? {
        return cellForItem(at: indexPath) as? T
    }
}
