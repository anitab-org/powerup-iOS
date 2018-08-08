import UIKit

/**
 Handles the entire popup lifecycle. Owns all popup views, media, and interactions.

 Example retrieving a model from the Popups dataset:
 ```
 // get the correct model
 let scenarioID = 5
 let popupID = 1
 guard let model: PopupEvent = PopupEvents().getPopup(type: .scenario,
                                                      collection: String(scenarioID),
                                                      popupID: popupID
 ) else {
    print("Could not retrieve outro story sequence for scenario \(scenarioID) with popupID \(popupID).")
    return
 }

 let event: PopupEventPlayer? = PopupEventPlayer(delegate: self, model: model)
 guard let popup = event else { return }
 popup.id = popupID
 self.view.addSubview(popup)
 ```

 Or use anywhere with a locally created model:
 ```
 func addPopup() {
    let model = PopupEvent(topText: "Made with ♥",
                           botText: "by Systers Open Source",
                           imgName: nil,
                           slideSound: nil,
                           badgeSound: nil)

    let popup: PopupEventPlayer = PopupEventPlayer(model)
    self.view.addSubview(popup)
 }
 ```

 Delegate methods: (optional)
 ```
 func popupDidShow(sender: PopupEventPlayer)
 func popupDidHide(sender: PopupEventPlayer)
 func popupWasTapped(sender: PopupEventPlayer)
 ```

 - Author: Cadence Holmes 2018
 */
class PopupEventPlayer: UIView {
    /* *******************************
     MARK: Properties
     ******************************* */
    weak var delegate: PopupEventPlayerDelegate?

    var id: Int?

    let angleSize: CGFloat = 0.1,
        slideAnimDuration: Double = 0.5,
        popupDuration: Double = 5.0,
        fontName: String = "Montserrat-Bold"

    var width: CGFloat,
        height: CGFloat

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
    var slideSound: String?
    var badgeSound: String?
    let defaultSounds = (slideIn: "placeholder",
                         showImage: "placeholder2")

    private var tapped: Bool

    enum AccessibilityIdentifiers: String {
        case popupEventPlayer = "popup-event-player"
    }

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

        super.init(frame: frame)

        self.accessibilityIdentifier = AccessibilityIdentifiers.popupEventPlayer.rawValue

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

    convenience init(delegate: PopupEventPlayerDelegate?, model: PopupEvent?) {
        self.init(frame: CGRect.zero)
        self.delegate = delegate

        guard let m = model else { return }

        if m.topText != nil {
            mainText = m.topText
            updateMainLabel()
        }
        if m.botText != nil {
            subText = m.botText
            updateSubLabel()
        }
        if m.imgName != nil {
            image = UIImage(named: m.imgName!)
            updateImageView()
        }
        if m.slideSound != nil {
            slideSound = m.slideSound!
        }
        if m.badgeSound != nil {
            badgeSound = m.badgeSound!
        }
    }

    convenience init(_ model: PopupEvent) {
        self.init(delegate: nil, model: model)
    }

    @objc func tapView(sender: UITapGestureRecognizer) {
        self.delegate?.popupWasTapped(sender: self)
        hide()
    }

    // setup view for debugging and animate view automatically when view is added to a superview
    override func didMoveToSuperview() {
        show()
    }

    /* *******************************
     MARK: Setup and Setters
     ******************************* */
    /**
     Size and layout subviews.
     */
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

    /**
     Animate text labels upwards.

     - Parameter label: `UILabel` to be animated.

     - Remark: References `slideAnimateDuration`.

     - Note: See `Animate`.
     */
    private func animateLabelText (_ label: UILabel) {
        Animate(label, slideAnimDuration * 2).fade(to: 1)
    }

    // setters to ensure views are updated if content changed after initialization
    /**
     Updates the main and sub labels.

     Calls `updateMainLabel()` and `updateSubLabel()`.
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

     Also updates `self.frame` to conform to the inner containers bounds.
     */
    func updateContainer() {
        let layer: CAShapeLayer = drawAngledShape()
        container.layer.addSublayer(layer)
        self.frame = container.bounds
    }

    // draw an angle on the left border, add shadow : called in updatedContainer()
    /**
     Draws the layer for the popup view, including the angled edge.

     - Returns: `CAShapeLayer` for the `PopupEventPlayer` view.
     */
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
     Animates showing the popup. Automatically called when an instance of PopupEventPlayer is added to a superview. See `didMoveToSuperview()`.

     Handles animations asyncronously on a background thread, checks for and plays sound, and times the popup for automatic dismissal.
     */
    func show() {

        self.delegate?.popupDidShow(sender: self)

        let volume: Float = 0.2

        let x = UIScreen.main.bounds.width - width
        animateSlideTo(x: x)
        playSound(fileName: slideSound, volume: volume)

        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.popupDuration) {
                self.hide()
            }
        }
    }

    // hide() is automatically called after show() + self.popupDuration
    /**
     Animates hiding the popup. Automatically called after `show()` + `popupDuration`, or when the popup is tapped.

     Handles animations asyncronously on a background thread, calls delegate method `popupDidFinish(sender:)`.
     */
    func hide() {
        if !tapped {
            tapped = true
            let x = UIScreen.main.bounds.width * 2
            animateSlideTo(x: x)

            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.asyncAfter(deadline: .now() + self.slideAnimDuration) {
                    self.delegate?.popupDidHide(sender: self)
                    self.removeFromSuperview()
                }
            }
        }
    }

    /* *******************************
     MARK: Private Class Methods
     ******************************* */
    /**
     Animate sliding the popup into view.

     - Parameter x: The distance to slide the popup.
     */
    private func animateSlideTo(x: CGFloat) {
        Animate(container, slideAnimDuration).move(to: [x, container.frame.origin.y], then: {
            if self.image != nil {
                self.animateShowImageWithSound()
            }
        })
    }

    /**
     Animate showing the badge image and call `playSound()`.
     */
    private func animateShowImageWithSound() {
        let duration: Double = 0.2
        let volume: Float = 0.1
        Animate(imageView, duration).setSpring(0.3, 12).reset().fade(to: 1)
        playSound(fileName: badgeSound, volume: volume)
    }

    /**
     Play a sound file once.

     - Parameter fileName: The name of the audio asset to be played.
     - Parameter volume: The volume at which the sound is played.
     */
    private func playSound (fileName: String?, volume: Float?) {
        if fileName != nil && !tapped {
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
    /**
     Called when `PopupEventPlayer` is successfully initialized and the view is added to the view hierarchy.
     */
    func popupDidShow(sender: PopupEventPlayer)
    /**
     Called when `PopupEventPlayer` is dismissed, whether by tapping or waiting for the duration.
     */
    func popupDidHide(sender: PopupEventPlayer)
    /**
     Called when `PopupEventPlayer` is tapped to hide.
     */
    func popupWasTapped(sender: PopupEventPlayer)
}
