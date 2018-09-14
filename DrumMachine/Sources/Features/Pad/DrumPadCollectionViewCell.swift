//
//  InstrumentCollectionViewCell.swift
//  FINN
//
//  Created by Markov, Vadym on 06/09/2018.
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

final class DrumPadCollectionViewCell: UICollectionViewCell {
    private lazy var overlayLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.init(white: 1, alpha: 0.8).cgColor
        return layer
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addInnerShadow(shadowColor: UIColor.red, shadowSize: 10, shadowOpacity: 0.1)
        contentView.layer.addSublayer(overlayLayer)
        setupStyles()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        overlayLayer.frame = contentView.bounds
        overlayLayer.cornerRadius = contentView.layer.cornerRadius
    }

    // MARK: - Styles

    func flash(withDuration duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0.5
        animation.duration = duration
        animation.autoreverses = true
        animation.repeatCount = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        contentView.layer.add(animation, forKey: nil)
    }

    func updateOverlayVisibility(isVisible: Bool) {
        overlayLayer.isHidden = !isVisible
    }

    private func setupStyles() {
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 2

        contentView.layer.borderColor = UIColor.white.cgColor
        updateOverlayVisibility(isVisible: false)
    }
}

// MARK: - Private extensions

private extension UIView {
    func addInnerShadow(shadowColor: UIColor, shadowSize: CGFloat, shadowOpacity: Float){
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowSize
        shadowLayer.fillRule = kCAFillRuleEvenOdd

        let shadowPath = CGMutablePath()
        let insetRect = bounds.insetBy(dx: -shadowSize * 2.0, dy: -shadowSize * 2.0)
        let innerFrame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)

        shadowPath.addRect(insetRect)
        shadowPath.addRect(innerFrame)

        shadowLayer.path = shadowPath
        layer.addSublayer(shadowLayer)
        clipsToBounds = true
    }
}
