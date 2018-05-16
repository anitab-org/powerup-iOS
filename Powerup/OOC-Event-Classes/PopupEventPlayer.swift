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
    let screenSize = UIScreen.main.bounds
    var soundPlayer : AVAudioPlayer?
    weak var delegate:PopupEventPlayerDelegate?

    var width : CGFloat,
        height : CGFloat
    
    var bgColor : UIColor? { didSet {updateContainer()} }
    var borderColor : UIColor? { didSet {updateContainer()} }
    var textColor : UIColor? { didSet {updateLabels()} }
    
    var mainText: String { didSet {updateMainLabel()} }
    var subText: String { didSet {updateSubLabel()} }

    var container : UIView,
        mainLabel : UILabel,
        subLabel: UILabel
    
    var tapped : Bool
    
    /* *******************************
    MARK: Initializers
    ******************************* */
    override init(frame: CGRect) {
        
        // initialize default properties
        self.width = self.screenSize.width * 0.8
        self.height = self.screenSize.height * 0.25
        
        self.bgColor = UIColor.cyan
        self.borderColor = UIColor.black
        self.textColor = UIColor.black
        
        self.mainText = ""
        self.subText = ""
        
        self.container = UIView(frame: CGRect(x: self.screenSize.width, y: 10, width: self.width, height: self.height))
        
        self.mainLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.subLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.tapped = false
        
        super.init(frame: frame)
        
        // add a tap gesture to manually dismiss the popup
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapView(sender:)))
        self.container.addGestureRecognizer(tap)
        
        // update subviews
        updateContainer()
        updateLabels()
        
        // add subviews
        self.addSubview(self.container)
    }
    
    convenience init(delegate: PopupEventPlayerDelegate) {
        self.init(frame: CGRect.zero)
        self.delegate = delegate
    }
    
    // animate view automatically when view is added to a superview
    override func didMoveToSuperview() {
        if self.superview != nil {
            show()
        }
    }
    
    // setters to ensure views are updated if changed after initialization
    func updateContainer() {
        let layer : CAShapeLayer = drawAngledShape()
        container.layer.addSublayer(layer)
        self.frame = container.bounds
    }
    
    func updateLabels() {
        updateMainLabel()
        updateSubLabel()
    }
    
    func updateMainLabel() {
        mainLabel.textColor = textColor
        mainLabel.text = mainText
    }
    
    func updateSubLabel() {
        subLabel.textColor = textColor
        subLabel.text = subText
    }
    
    // draw an angle on the left border, add shadow
    func drawAngledShape() -> CAShapeLayer {
        let borderWidth : CGFloat = 1.5
        let angleSize : CGFloat = 0.1
        
        let bounds = container.bounds
        let layer = CAShapeLayer()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: bounds.width, y: 0))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.width*angleSize, y: bounds.height))
        path.close()
        
        layer.path = path.cgPath
        layer.fillColor = bgColor?.cgColor
        layer.strokeColor = borderColor?.cgColor
        layer.lineWidth = borderWidth
        
        layer.shadowPath = layer.path
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 10
        
        return layer
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
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
    
    @objc func tapView(sender: UITapGestureRecognizer) {
        hide()
        tapped = true
    }
    
    // automatically called when instance is added to a superview
    // animate and play sound on a background thread, wait, automatically dismiss the view
    func show() {
        let hideDelay : Double = 3.0
        let volume : Float = 0.2
        let sound = "placeholder"
        
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                let x = self.screenSize.width-self.width
                self.animateSlide(x)
                self.playSound(sound, volume)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + hideDelay) {
                self.hide()
            }
        }
    }
    
    func hide() {
        if !tapped {
            let animationLength : Double = 0.5
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    self.animateSlide(self.screenSize.width)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + animationLength) {
                    self.removeFromSuperview()
                    self.container.removeFromSuperview()
                    self.delegate?.popupDidFinish(sender: self)
                }
            }
        }
    }
    
    func animateSlide(_ x: CGFloat) {
        let duration : Double = 0.5
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
        animations: {
            self.container.frame = CGRect(x: x, y: 10, width: self.width, height: self.height)
        }, completion: { (finished: Bool) in
            
        })
    }
    
    func playSound(_ fileName: String,_ volume: Float) {
        guard let sound = NSDataAsset(name: fileName) else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            if #available(iOS 11.0, *) {
                soundPlayer = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileType.mp3.rawValue)
            } else {
                soundPlayer = try AVAudioPlayer(data: sound.data)
            }
            
            guard let player = soundPlayer else { return }
            player.volume = volume
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

/* *******************************
 MARK: Delegate Methods
 ******************************* */
protocol PopupEventPlayerDelegate: AnyObject {
    func popupDidFinish(sender: PopupEventPlayer)
}
