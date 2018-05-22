//
//  StorySequencePlayer.swift
//  Powerup
//
//  Created by KD on 5/15/18.
//  Copyright © 2018 Systers. All rights reserved.
//

import UIKit

class StorySequencePlayer: UIView {
    /* *******************************
     MARK: Properties
     ******************************* */
    weak var delegate: StorySequencePlayerDelegate?

    var textContainer: UIView,
        imageViewContainer: UIView,
        leftImageView: UIImageView,
        rightImageView: UIImageView

    var leftImage: UIImage?,
        rightImage: UIImage?

    var model: StorySequence,
        currentStep: Int

    /* *******************************
     MARK: Initializers
     ******************************* */
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    override init(frame: CGRect) {
        self.model = StorySequence([:])
        self.textContainer = UIView(frame: CGRect.zero)
        self.imageViewContainer = UIView(frame: CGRect.zero)
        self.leftImageView = UIImageView(frame: CGRect.zero)
        self.rightImageView = UIImageView(frame: CGRect.zero)
        self.currentStep = -1

        super.init(frame: frame)

        let margin: CGFloat = 10
        let imageViewHeight: CGFloat = 0.6

        addBlur()
        layoutImageViews(margin, imageViewHeight)
        layoutTextContainer(margin, 1 - imageViewHeight)
        addTapGesture()
    }

    convenience init(delegate: StorySequencePlayerDelegate, model: StorySequence) {
        self.init(frame: UIScreen.main.bounds)

        self.delegate = delegate
        self.model = model

        checkCurrentStep()
    }

    //    override func didMoveToSuperview() {
    //        if self.superview != nil {
    //        }
    //    }

    /* *******************************
     MARK: Setup and Setters
     ******************************* */
    private func addBlur() {
        let blur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurView)
    }

    private func layoutImageViews(_ margin: CGFloat, _ height: CGFloat) {
        let containerW = self.bounds.width - (margin * 2)
        let containerH = self.bounds.height * height

        imageViewContainer.frame = CGRect(x: margin, y: self.bounds.height - containerH, width: containerW, height: containerH)

        let bounds = imageViewContainer.bounds
        let imageWidth: CGFloat = bounds.width * 0.3
        let imageHeight: CGFloat = bounds.height

        let leftRect = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        let rightRect = CGRect(x: bounds.width - imageWidth, y: 0, width: imageWidth, height: imageHeight)

        leftImageView.frame = leftRect
        rightImageView.frame = rightRect

        leftImageView.contentMode = .scaleAspectFit
        rightImageView.contentMode = .scaleAspectFit

        imageViewContainer.backgroundColor = UIColor.green
        leftImageView.backgroundColor = UIColor.red
        leftImageView.alpha = 0.2
        rightImageView.backgroundColor = UIColor.blue
        rightImageView.alpha = 0.2

        imageViewContainer.addSubview(leftImageView)
        imageViewContainer.addSubview(rightImageView)
        self.addSubview(imageViewContainer)
    }

    private func layoutTextContainer(_ margin: CGFloat, _ height: CGFloat) {
        let containerW = self.bounds.width - (margin * 2)
        let containerH = (self.bounds.height * height) - margin
        textContainer.frame = CGRect(x: margin, y: margin, width: containerW, height: containerH)

        textContainer.backgroundColor = UIColor.cyan
        textContainer.alpha = 0.2

        self.addSubview(textContainer)
    }

    // add a tap gesture to manually dismiss the popup
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapView(sender:)))
        self.addGestureRecognizer(tap)
    }

    @objc private func tapView(sender: UITapGestureRecognizer) {
        checkCurrentStep()
    }

    private func checkCurrentStep() {
        if currentStep < model.steps.count - 1 {
            currentStep = currentStep + 1
            updateToCurrentStep()
        } else {
            hide()
        }
    }

    private func updateToCurrentStep() {

    }

    /* *******************************
     MARK: Public Class Methods
     ******************************* */
    func hide() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: {
                           self.alpha = 0
                       }, completion: { (finished: Bool) in
                           self.delegate?.sequenceDidFinish(sender: self)
                       })
    }
}

/* *******************************
 MARK: Delegate Methods
 ******************************* */
protocol StorySequencePlayerDelegate: AnyObject {
    func sequenceDidFinish(sender: StorySequencePlayer)
}
