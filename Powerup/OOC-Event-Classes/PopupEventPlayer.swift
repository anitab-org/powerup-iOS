import UIKit
import AVFoundation

/**
 Handles the entire popup lifecycle. Owns all popup views, media, and interactions.
 - Author: Cadence Holmes
 */
class PopupEventPlayer: UIView {
    /* *******************************
     MARK: Properties
     ******************************* */
    weak var delegate: PopupEventPlayerDelegate?

    let angleSize: CGFloat = 0.1,
        slideAnimDuration: Double = 0.5,
        popupDuration: Double = 5.0,
        fontName: String = "Montserrat-Bold"

    var width: CGFloat,
        height: CGFloat
    var useSound: Bool

    var bgColor: UIColor // { didSet { updateContainer() } }
    var borderColor: UIColor // { didSet { updateContainer() } }
    var textColor: UIColor // { didSet { updateLabels() } }

    var mainText: String? // { didSet { updateMainLabel() } }
    var subText: String? // { didSet { updateSubLabel() } }

    var image: UIImage? // { didSet { updateImageView() } }

    var container: UIView,
        mainLabel: UILabel,
        subLabel: UILabel,
        imageView: UIImageView

    var soundPlayer: SoundPlayer? = SoundPlayer()
    let sounds = (slideIn: "placeholder",
                  showImage: "placeholder2")

    private var tapped: Bool

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
        self.bgColor = UIColor.init(red: 129 / 255.0, green: 236 / 255.0, blue: 236 / 255.0, alpha: 1.0)
        self.borderColor = UIColor.black
        self.textColor = UIColor.black

        self.container = UIView(frame: CGRect.zero)
        self.mainLabel = UILabel(frame: CGRect.zero)
        self.subLabel = UILabel(frame: CGRect.zero)
        self.imageView = UIImageView(frame: CGRect.zero)

        self.tapped = false
        self.useSound = false

        super.init(frame: frame)

        // setup subviews
        setupSubviews()
        updateContainer()

        // add a tap gesture to manually dismiss the popup
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapView(sender:)))
        self.container.addGestureRecognizer(tap)

        // add subviews
        container.addSubview(mainLabel)
        container.addSubview(subLabel)
        container.addSubview(imageView)
        self.addSubview(self.container)
    }

//    func setupForDebug(_ superview: UIView) {
//        let popups = superview.subviews.filter({ $0 is PopupEventPlayer })
//        self.accessibilityIdentifier = "PopupEventPlayer-\(popups.count)"
//    }

    @objc func tapView(sender: UITapGestureRecognizer) {
        self.useSound = false
        hide()
        tapped = true
    }

    convenience init(delegate: PopupEventPlayerDelegate, model: PopupEvent) {
        self.init(frame: CGRect.zero)
        self.delegate = delegate

        if model.topText != nil {
            mainText = model.topText
            updateMainLabel()
        }
        if model.botText != nil {
            subText = model.botText
            updateSubLabel()
        }
        if model.imgName != nil {
            image = UIImage(named: model.imgName!)
            updateImageView()
        }
        if model.doSound != nil {
            useSound = model.doSound!
        }
    }

    // setup view for debugging and animate view automatically when view is added to a superview
    override func didMoveToSuperview() {
        guard let superview = self.superview else { return }
        setupForDebug(superview)
        show()
    }

    /* *******************************
     MARK: Setup and Setters
     ******************************* */
    private func setupSubviews() {
        container.frame = CGRect(x: UIScreen.main.bounds.width, y: 10, width: width, height: height)

        // compute label frames
        let angleOffset = width * angleSize
        let constrainW = container.bounds.width - angleOffset // set label contraints
        let constrainH = container.bounds.height
        let labelWidth = constrainW * 0.9 // shared label width
        let labelHeight = constrainH * 0.9 // combined label height
        let mainLabelHeight = labelHeight * 0.65
        let subLabelHeight = labelHeight - mainLabelHeight
        let offsetY = (constrainH - labelHeight) / 2 // set margins
        let offsetX = ((constrainW - labelWidth) / 2) + angleOffset

        mainLabel.frame = CGRect(x: offsetX, y: offsetY, width: labelWidth, height: mainLabelHeight)
        subLabel.frame = CGRect(x: offsetX, y: offsetY + mainLabelHeight, width: labelWidth, height: subLabelHeight)

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

        imageView.frame = CGRect(x: -(size / 5), y: size / 4, width: size, height: size)
        imageView.layer.transform = CATransform3DScale(rotateTransform, shrink, shrink, shrink)
        imageView.layer.opacity = 0
        imageView.contentMode = .scaleAspectFit
    }

    private func animateLabelText (_ label: UILabel) {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.slideAnimDuration * 2,
                               delay: 0,
                               options: .curveEaseInOut,
                               animations: {
                                   label.layer.opacity = 1
                               }, completion: { (finished: Bool) in

                               })
            }
        }
    }

    // setters to ensure views are updated if content changed after initialization
    /**
     Updates the main and sub labels.

     Calls `self.updateMainLabel()` and `self.updateSubLabel()`.
     */
    func updateLabels() {
        updateMainLabel()
        updateSubLabel()
    }

    /**
     Updates the main label.

     References relevant class properties and updates the upper text label *with* fade-in animations.
     */
    func updateMainLabel() {
        mainLabel.textColor = textColor
        guard let text = mainText else { return }
        mainLabel.text = text
        animateLabelText(mainLabel)
    }

    /**
     Updates the sub label.

     References relevant class properties and updates the lower text label *with* fade-in animations.
     */
    func updateSubLabel() {
        subLabel.textColor = textColor
        guard let text = subText else { return }
        subLabel.text = text
        animateLabelText(subLabel)
    }

    /**
     Updates the image view.

     References relevant class properties and updates the image view *without* animations. Animations are handled when the class is implemented and added to a superview.
     */
    func updateImageView() {
        guard let image = image else { return }
        imageView.image = image
    }

    /**
     Draws the inner container layer (angle and shadow).

     Also updates self.frame to conform to the inner containers bounds.
     */
    func updateContainer() {
        let layer: CAShapeLayer = drawAngledShape()
        container.layer.addSublayer(layer)
        self.frame = container.bounds
    }

    // draw an angle on the left border, add shadow : called in updatedContainer()
    private func drawAngledShape() -> CAShapeLayer {
        let borderWidth: CGFloat = 1.5

        let bounds = container.bounds
        let layer = CAShapeLayer()

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: bounds.width, y: 0))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.width * angleSize, y: bounds.height))
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

    /* *******************************
     MARK: Public Class Methods
     ******************************* */
    /**
     Animates showing the popup. Automatically called when an instance of PopupEventPlayer is added to a superview. See `override func didMoveToSuperview()`.

     Handles animations asyncronously on a background thread, checks for and plays sound, and times the popup for automatic dismissal.
     */
    func show() {
        let sound = sounds.slideIn
        let volume: Float = 0.2

        let x = UIScreen.main.bounds.width - self.width
        self.animateSlideToWithSound(x: x, sound: sound, volume: volume)

        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.popupDuration) {
                self.hide()
            }
        }
    }

    // hide() is automatically called after show() + self.popupDuration
    /**
     Animates hiding the popup. Automatically called after show() + self.popupDuration, or when the popup is tapped.

     Handles animations asyncronously on a background thread, calls delegate method `.popupDidFinish(sender: self)`.
     */
    func hide() {
        if !tapped {
            let x = UIScreen.main.bounds.width * 2
            self.animateSlideToWithSound(x: x, sound: nil, volume: nil)

            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.asyncAfter(deadline: .now() + self.slideAnimDuration) {
                    self.delegate?.popupDidFinish(sender: self)
                }
            }
        }
    }

    /* *******************************
     MARK: Private Class Methods
     ******************************* */
    private func animateSlideToWithSound(x: CGFloat, sound: String?, volume: Float?) {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.slideAnimDuration,
                               delay: 0,
                               usingSpringWithDamping: 1,
                               initialSpringVelocity: 1,
                               options: .curveEaseOut,
                               animations: {
                                   self.container.frame.origin.x = x
                                   self.playSound(fileName: sound, volume: volume)
                               }, completion: { (finished: Bool) in
                                   if self.image != nil {
                                       self.animateShowImageWithSound()
                                   }
                               })
            }
        }

    }

    private func animateShowImageWithSound() {
        let duration: Double = 0.2
        let sound = sounds.showImage
        let volume: Float = 0.1
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
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
        }
    }

    private func playSound (fileName: String?, volume: Float?) {
        if self.useSound {
            guard let sound = fileName else { return }
            guard let player = self.soundPlayer else { return }
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
