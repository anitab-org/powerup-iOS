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

    let fontName: String = "Montserrat-Bold",
        fontSize: CGFloat = 16

    var textContainer: UIView,
        imageViewContainer: UIView,
        leftImageView: UIImageView,
        rightImageView: UIImageView

    var model: StorySequence,
        currentStep: Int

    var imgNear: CGFloat,
        imgMid: CGFloat,
        imgFar: CGFloat

    private var canTap: Bool

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
        self.canTap = false

        self.imgNear = 0
        self.imgMid = 0
        self.imgFar = 0

        super.init(frame: frame)

        let margin: CGFloat = 10
        let imageViewHeight: CGFloat = 0.6

        addBlur(self)
        layoutImageViews(margin, imageViewHeight)
        layoutTextContainer(margin, 1 - imageViewHeight)
        addTapGesture()
    }

    convenience init(delegate: StorySequencePlayerDelegate, model: StorySequence) {
        self.init(frame: UIScreen.main.bounds)

        self.delegate = delegate
        self.model = model

        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.checkCurrentStep()
            }
        }
    }

    /* *******************************
     MARK: Private Class Functions
     ******************************* */
    private func addBlur(_ view: UIView) {
        let blur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurView)
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

        imgMid = (imageViewContainer.bounds.width / 4) - (imageWidth / 2)
        imgFar = (imageViewContainer.bounds.width / 2) - imageWidth

        moveImage(pos: .hidden, view: leftImageView, left: true)
        moveImage(pos: .hidden, view: rightImageView, left: false)

//        imageViewContainer.backgroundColor = UIColor.green
//        leftImageView.backgroundColor = UIColor.red
//        leftImageView.alpha = 0.2
//        rightImageView.backgroundColor = UIColor.blue
//        rightImageView.alpha = 0.2

        imageViewContainer.addSubview(leftImageView)
        imageViewContainer.addSubview(rightImageView)
        self.addSubview(imageViewContainer)
    }

    private func layoutTextContainer(_ margin: CGFloat, _ height: CGFloat) {
        let containerW = self.bounds.width - (margin * 2)
        let containerH = (self.bounds.height * height) - (margin * 2)
        textContainer.frame = CGRect(x: margin, y: margin, width: containerW, height: containerH)

//        textContainer.backgroundColor = UIColor.cyan
//        textContainer.alpha = 0.2

        textContainer.layer.masksToBounds = true
        textContainer.layer.cornerRadius = 12

        //addBlur(textContainer)
        self.addSubview(textContainer)
    }

    // add a tap gesture to manually step through the story sequence
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapView(sender:)))
        self.addGestureRecognizer(tap)
    }

    @objc private func tapView(sender: UITapGestureRecognizer) {
        if canTap {
            checkCurrentStep()
        }
    }

    // check if there is another step, update count and call ui updates, else hide and dismiss
    private func checkCurrentStep() {
        // stop interactions, enabled after updateToCurrentStep is complete
        self.canTap = false
        if currentStep < model.steps.count - 1 {
            currentStep = currentStep + 1
            updateToCurrentStep()
        } else {
            hide()
        }
    }

    // these functions check for data in the model and calls the appropriate updates
    private func updateToCurrentStep() {
        updateLeftSide()
        updateRightSide()
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.canTap = true
            }
        }
    }

    private func updateLeftSide() {
        guard let m = model.steps[currentStep]!.lftEvent else { return }
        if m.image != nil {
            changeImage(imageView: leftImageView, image: m.image!)
        }
        if m.position != nil {
            moveImage(pos: m.position!, view: leftImageView, left: true)
        }
        if m.imgAnim != nil {

        }
        if m.text != nil {
            let label = self.makeLabel(text: m.text!, left: true)
            self.textContainer.addSubview(label)
            shiftLabels(then: {

            })
        }
    }

    private func updateRightSide() {
        guard let m = model.steps[currentStep]!.rgtEvent else { return }
        if m.image != nil {
            changeImage(imageView: rightImageView, image: m.image!)
        }
        if m.position != nil {
            moveImage(pos: m.position!, view: rightImageView, left: false)
        }
        if m.imgAnim != nil {

        }
        if m.text != nil {
            let label = self.makeLabel(text: m.text!, left: false)
            self.textContainer.addSubview(label)
            shiftLabels(then: {

            })
        }
    }

    // return a formatted label
    private func makeLabel(text: String, left: Bool) -> UILabel {
        // determine properties based on container bounds
        let margin: CGFloat = 10
        let bounds = textContainer.bounds
        let width = (bounds.width - (margin * 4)) / 2
        let height = (bounds.height - (margin * 2)) / 4
        let y = bounds.height - margin
        // determine if it's on the left or right side
        var x = margin
        if !left {
            x = bounds.width - width - margin
        }
        let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))

        // set basic properties
        label.textColor = UIColor.white
        label.font = UIFont(name: fontName, size: fontSize)
        label.text = text
        if !left {
            label.textAlignment = .right
        }

        // resize and reformat to account for word wrapping
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = width
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.sizeToFit()

        // force width back to original value, check that height isn't too small
        label.frame.size.width = width
        if label.frame.size.height < height {
            label.frame.size.height = height
        }

        return label
    }

    // shift labels up as new labels are added
    private func shiftLabels(then: (() -> ())?) {
        let labels = textContainer.subviews
        let dur = 0.5

        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                // get the height of the newly added label and shift all labels by that amount + a buffer
                var height: CGFloat = 0
                let buffer: CGFloat = 15
                if labels.count > 0 {
                    height = labels.last!.frame.size.height + buffer
                }
                // loop through and shift the labels, reduce alpha for old labels
                for label in labels {
                    UIView.animate(withDuration: dur,
                                   delay: 0,
                                   usingSpringWithDamping: 0.6,
                                   initialSpringVelocity: 6.8 + (self.randomCGFloat() * 5),
                                   options: .curveEaseOut,
                                   animations: {
                                       if label != labels.last {
                                           if label.alpha == 1 {
                                               label.alpha = 0.4
                                           }
                                       }
                                       label.frame.origin.y = label.frame.origin.y - height
                                   }, completion: { (finished: Bool) in
                                   })
                }
            }
            
            // wait until shifting animations are done, and deal with labels moving off screen
            DispatchQueue.main.asyncAfter(deadline: .now() + dur) {
                for label in labels {
                    // remove old labels
                    if label.alpha == 0 {
                        label.removeFromSuperview()
                    }
                    // fade out labels if that may be partially on screen
                    if label.frame.origin.y < 0 {
                        print("\n\(label.frame.origin)")
                        self.fadeAlpha(view: label, alpha: 0, duration: 0.8, then: nil)
                    }
                }
            }
        }

        // call completion handler after shifting
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + dur) {
                then?()
            }
        }
    }

    // returns a random CGFloat 0 - 1
    private func randomCGFloat() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }

    // fade out view, then change image, then fade in view
    private func changeImage(imageView: UIImageView, image: String) {
        let duration = 0.1
        fadeAlpha(view: imageView, alpha: 0.1, duration: duration, then: {
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    imageView.image = UIImage(named: image)
                    self.fadeAlpha(view: imageView, alpha: 1, duration: duration, then: nil)
                }
            }
        })
    }

    // fade view with completion handler
    private func fadeAlpha(view: UIView, alpha: CGFloat, duration: Double, then: (() -> ())?) {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: duration,
                               delay: 0,
                               usingSpringWithDamping: 1,
                               initialSpringVelocity: 1,
                               options: .curveEaseOut,
                               animations: {
                                   view.alpha = alpha
                               }, completion: { (finished: Bool) in
                                   then?()
                               })
            }
        }
    }

    // determine x position and animate moving the imageView
    private func moveImage(pos: StorySequence.StorySequenceImagePosition, view: UIImageView, left: Bool) {
        var x: CGFloat

        switch pos {
        case .near:
            x = 0
        case .mid:
            x = imgMid
        case .far:
            x = imgFar
        case .hidden:
            x = -view.frame.width * 2
        case .dismiss:
            x = -view.frame.width * 2
        }

        if !left {
            x = imageViewContainer.bounds.width - view.bounds.width - x
        }

        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 1,
                               initialSpringVelocity: 1,
                               options: .curveEaseOut,
                               animations: {
                                   view.frame.origin.x = x
                               }, completion: { (finished: Bool) in

                               })
            }
        }
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
