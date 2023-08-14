//
//  DrumsFooterView.swift
//  DrumMachine
//
//  Created by Markov, Vadym on 06/09/2018.
//  Copyright © 2018 FINN.no AS. All rights reserved.
//


//This is where the "Reset" and "Close" buttons are

import UIKit

final class DrumsFooterView: UIView {
    private(set) lazy var leftButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.ice, for: .normal)
        return button
    }()

    private(set) lazy var rightButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.cherry, for: .normal)
        return button
    }()
    
    

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(leftButton)
        addSubview(rightButton)
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func setupConstraints() {
        let padding: CGFloat = 16
        NSLayoutConstraint.activate([
            leftButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            leftButton.heightAnchor.constraint(equalTo: heightAnchor),
            leftButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),

            rightButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            rightButton.heightAnchor.constraint(equalTo: heightAnchor),
            rightButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
        ])
    }
}
