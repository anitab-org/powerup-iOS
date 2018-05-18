//
//  PopupEventPlayer.swift
//  Powerup
//
//  Created by KD on 5/15/18.
//  Copyright © 2018 Systers. All rights reserved.
//

import UIKit
import AVFoundation

class PopupEventPlayer : UIView {
    /* *******************************
    MARK: Properties
    ******************************* */
    weak var delegate:PopupEventPlayerDelegate?
    
    var width : CGFloat,
        height : CGFloat,
        tapped : Bool
    var useSound : Bool?
    
    var bgColor : UIColor { didSet {updateContainer()} }
    var borderColor : UIColor { didSet {updateContainer()} }
    var textColor : UIColor { didSet {updateLabels()} }
    
    var mainText : String? { didSet {updateMainLabel()} }
    var subText : String? { didSet {updateSubLabel()} }
    
    var image : UIImage? { didSet {updateImageView()} }
    
    var container : UIView,
        mainLabel : UILabel,
        subLabel : UILabel,
        imageView : UIImageView
    
    let angleSize : CGFloat = 0.1,
        slideAnimDuration : Double = 0.5,
        popupDuration : Double = 3.0,
        fontName : String = "Montserrat-Bold"
    
    var soundPlayer : SoundPlayer? = SoundPlayer()
    let sounds = (slideIn: "placeholder",
                  showImage: "placeholder2")
    
    /* *******************************
    MARK: Initializers
    ******************************* */
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    override init(frame: CGRect) {
        
        // initialize non-optional properties
        self.width = UIScreen.main.bounds.width * 0.8
        self.height = UIScreen.main.bounds.height * 0.25
        self.bgColor = UIColor.init(red: 129/255.0, green: 236/255.0, blue: 236/255.0, alpha: 1.0)
        self.borderColor = UIColor.black
        self.textColor = UIColor.black
        
        self.container = UIView(frame: CGRect.zero)
        self.mainLabel = UILabel(frame: CGRect.zero)
        self.subLabel = UILabel(frame: CGRect.zero)
        self.imageView = UIImageView(frame: CGRect.zero)
        
        self.tapped = false
        
        super.init(frame: frame)
        
        // setup subviews
        setupSubviews()
        updateContainer()
//        updateLabels()
//        updateImageView()
        
        // add a tap gesture to manually dismiss the popup
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapView(sender:)))
        self.container.addGestureRecognizer(tap)
        
        // add subviews
        container.addSubview(mainLabel)
        container.addSubview(subLabel)
        container.addSubview(imageView)
        self.addSubview(self.container)
    }
    
    @objc func tapView(sender: UITapGestureRecognizer) {
        hide()
        tapped = true
    }
    
    convenience init(delegate: PopupEventPlayerDelegate, model: PopupEvent) {
        self.init(frame: CGRect.zero)
        self.delegate = delegate
        if model.mainText != nil {
            mainText = model.mainText
            updateMainLabel()
        }
        if model.subText != nil {
            subText = model.subText
            updateSubLabel()
        }
        if model.image != nil {
            image = UIImage(named: model.image!)
            updateImageView()
        }
        if model.useSound != nil {
            useSound = model.useSound
        }
    }
    
    // animate view automatically when view is added to a superview
    override func didMoveToSuperview() {
        if self.superview != nil {
            show()
        }
    }
    
    /* *******************************
     MARK: Setup and Setters
     ******************************* */
    // setup labels and imageview
    func setupSubviews() {
        container.frame = CGRect(x: UIScreen.main.bounds.width, y: 10, width: width, height: height)
        
        // compute label frames
        let angleOffset     = width * angleSize
        let constrainW      = container.bounds.width - angleOffset          // set label contraints
        let constrainH      = container.bounds.height
        let labelWidth      = constrainW * 0.9                              // shared label width
        let labelHeight     = constrainH * 0.9                              // combined label height
        let mainLabelHeight = labelHeight * 0.65
        let subLabelHeight  = labelHeight - mainLabelHeight
        let offsetY         = (constrainH - labelHeight) / 2                // set margins
        let offsetX         = ((constrainW - labelWidth) / 2) + angleOffset
        
        mainLabel.frame = CGRect(x: offsetX, y: offsetY, width: labelWidth, height: mainLabelHeight)
        subLabel.frame = CGRect(x: offsetX, y: offsetY+mainLabelHeight, width: labelWidth, height: subLabelHeight)
        
        mainLabel.font = UIFont(name: fontName, size: 30)
        subLabel.font = UIFont(name: fontName, size: 15)
        mainLabel.textAlignment = .center
        subLabel.textAlignment = .center
        mainLabel.adjustsFontSizeToFitWidth = true
        subLabel.adjustsFontSizeToFitWidth = true
        mainLabel.layer.opacity = 0
        subLabel.layer.opacity = 0
        
        let size = constrainH * 0.9
        let degrees = -90.0
        let radians = CGFloat(degrees * Double.pi / 180)
        let rotateTransform = CATransform3DMakeRotation(radians, 0, 0, 1)
        let shrink = CGFloat(0.1)
        
        imageView.frame = CGRect(x: -(size/5), y: size/4, width: size, height: size)
        imageView.layer.transform = CATransform3DScale(rotateTransform, shrink, shrink, shrink)
        imageView.layer.opacity = 0
        imageView.contentMode = .scaleAspectFit
        
        // temporary: for testing
//        mainLabel.backgroundColor = UIColor.init(red: 1.0, green: 0, blue: 0, alpha: 0.3)
//        subLabel.backgroundColor = UIColor.init(red: 0, green: 1.0, blue: 0, alpha: 0.3)
//        imageView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 1.0, alpha: 0.3)
//        mainText = "testing the main label"
//        subText = "testing the sub label"
//        image = UIImage(named: "karma_star")
    }
    
    func animateLabelText (_ label: UILabel) {
        
        UIView.animate(withDuration: slideAnimDuration*2,
                       delay: 0,
                       options: .curveEaseInOut,
        animations: {
            label.layer.opacity = 1
        }, completion: { (finished: Bool) in
        
        })
    }
    
    // setters to ensure views are updated if content changed after initialization
    func updateLabels() {
        updateMainLabel()
        updateSubLabel()
    }
    
    func updateMainLabel() {
        mainLabel.textColor = textColor
        guard let text = mainText else {return}
        mainLabel.text = text
        animateLabelText(mainLabel)
    }
    
    func updateSubLabel() {
        subLabel.textColor = textColor
        guard let text = subText else {return}
        subLabel.text = text
        animateLabelText(subLabel)
    }
    
    func updateImageView() {
        guard let image = image else {return}
        imageView.image = image
    }
    
    func updateContainer() {
        let layer : CAShapeLayer = drawAngledShape()
        container.layer.addSublayer(layer)
        self.frame = container.bounds
    }
    
    // draw an angle on the left border, add shadow : called in updatedContainer()
    func drawAngledShape() -> CAShapeLayer {
        let borderWidth : CGFloat = 1.5
        
        let bounds = container.bounds
        let layer = CAShapeLayer()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: bounds.width, y: 0))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.width*angleSize, y: bounds.height))
        path.close()
        
        layer.path = path.cgPath
        layer.fillColor = bgColor.cgColor
        layer.strokeColor = borderColor.cgColor
        layer.lineWidth = borderWidth
        
        layer.shadowPath = layer.path
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 10
        
        return layer
    }
    
    // for debugging purposes
//    override var description : String {
//        get {
//            return "\nPopupEventPlayer:\n  mainText: \(mainText);\n  subText: \(subText);\n  container: \(container)"
//        }
//    }
    
    /* *******************************
     MARK: Class Methods
     ******************************* */
    
    // show() is automatically called when instance is added to a superview
    // animate and play sound on a background thread, wait, automatically dismiss the view
    func show() {
        let sound = sounds.slideIn
        let volume : Float = 0.2
        
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                let x = UIScreen.main.bounds.width-self.width
                self.animateSlideToWithSound(x: x, sound: sound, volume: volume)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + self.popupDuration) {
                self.hide()
            }
        }
    }
    
    // hide() is automatically called after show() + self.popupDuration
    func hide() {
        if !tapped {
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    let x = UIScreen.main.bounds.width * 2
                    self.animateSlideToWithSound(x: x, sound: nil, volume: nil)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + self.slideAnimDuration) {
                    self.removeFromSuperview()
                    self.container.removeFromSuperview()
                    self.delegate?.popupDidFinish(sender: self)
                }
            }
        }
    }
    
    func animateSlideToWithSound(x: CGFloat, sound: String?, volume: Float?) {
        UIView.animate(withDuration: slideAnimDuration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
        animations: {
            self.container.frame = CGRect(x: x, y: 10, width: self.width, height: self.height)
            self.playSound(fileName: sound, volume: volume)
        }, completion: { (finished: Bool) in
            if self.image != nil {
                self.animateShowImageWithSound()
            }
        })
    }
    
    func animateShowImageWithSound() {
        let duration : Double = 0.2
        let sound = sounds.showImage
        let volume : Float = 0.1
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 12,
                       options: .curveEaseOut,
        animations: {
            self.imageView.layer.transform = CATransform3DIdentity
            self.imageView.layer.opacity = 1
            self.playSound(fileName: sound, volume: volume)
        }, completion: { (finished: Bool) in
        
        })
    }
    
    func playSound (fileName: String?, volume: Float?) {
        if self.useSound! {
            guard let sound = fileName else {return}
            guard let player = self.soundPlayer else {return}
            let vol = (volume != nil) ? volume : 1
            player.playSound(sound, vol!)
        }
    }
    
}

/* *******************************
 MARK: Delegate Methods
 ******************************* */
protocol PopupEventPlayerDelegate: AnyObject {
    func popupDidFinish(sender: PopupEventPlayer)
}
