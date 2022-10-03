//
//  InstrumentCollectionViewCell.swift
//  FINN
//
//  Created by Markov, Vadym on 06/09/2018.
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

//A DrumPadCollectionViewCell class is defined of type UICollectionViewCell
final class DrumPadCollectionViewCell: UICollectionViewCell {
    //a lazy var overlayLayer is made, a subclass of CALayer
    private lazy var overlayLayer: CALayer = {
        //layer is used as a placeeholder within the function
        let layer = CALayer()
        //various aesthetic customizations are modified from the CALayer parent class
        layer.backgroundColor = UIColor.init(white: 1, alpha: 0.8).cgColor
        //the placeholder instance is returned back to the parent class
        return layer
    }()

    // MARK: - Init

    
    //a rectangle is initialized as an instance of the CGRect class
    override init(frame: CGRect) {
        super.init(frame: frame)
        //aesthetic properties are modified
        contentView.addInnerShadow(shadowColor: UIColor.red, shadowSize: 10, shadowOpacity: 0.1)
        //the overlayLater CALayer is passed into the addSublayer method of CGRect
        contentView.layer.addSublayer(overlayLayer)
        //a function setupStyles() is ran
        setupStyles()
    }

    //a test is run to check for succesful initialization
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    
    
//I think this is giving instructions for how the tiles should be laid out, and constrains them to be within the contentView
    override func layoutSubviews() {
        super.layoutSubviews()
        overlayLayer.frame = contentView.bounds
        overlayLayer.cornerRadius = contentView.layer.cornerRadius
    }

    // MARK: - Styles
    
//a flash effect is made
    func flash(withDuration duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0.5
        animation.duration = duration
        animation.autoreverses = true
        animation.repeatCount = 1
////        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunction).easeInEaseOut)
//        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunction).easeInEaseOut
        contentView.layer.add(animation, forKey: nil)
    }

    
    //a function is made that updates overLayer.isHidden when passed a Boolean
    func updateOverlayVisibility(isVisible: Bool) {
        overlayLayer.isHidden = !isVisible
    }

    
    //this sets up the stiles
    private func setupStyles() {
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 2

        contentView.layer.borderColor = UIColor.white.cgColor
        updateOverlayVisibility(isVisible: false)
    }
}

// MARK: - Private extensions

//this extends the UIView class for aesthetic purposes
private extension UIView {
    func addInnerShadow(shadowColor: UIColor, shadowSize: CGFloat, shadowOpacity: Float){
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowSize
        shadowLayer.fillRule = CAShapeLayerFillRule.evenOdd

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
