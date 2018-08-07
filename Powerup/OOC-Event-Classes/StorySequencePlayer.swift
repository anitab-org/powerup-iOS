import UIKit

/**
 Handles the entire story sequence lifecycle. Owns all views, media, and interactions.

 Example use:
 ```
 let scenarioID = 5
 guard let model = StorySequences().getStorySequence(scenario: scenarioID) else {
 print("Could not retrieve intro story sequence for scenario \(scenarioID).")
 return
 }

 let sequenceView: StorySequencePlayer = StorySequencePlayer(delegate: self, model: model, firstTime: firstTime())
 self.view.addSubview(sequenceView)
 ```

 Delegate methods: (optional)
 ```
 func sequenceDidStart(sender: StorySequencePlayer)
 func sequenceDidFinish(sender: StorySequencePlayer)
 func sequenceWasSkipped(sender: StorySequencePlayer)
 ```

 - Author: Cadence Holmes 2018
 */
class StorySequencePlayer: UIView {
    /* *******************************
     MARK: Properties
     ******************************* */
    weak var delegate: StorySequencePlayerDelegate?

    let fontName: String = "Montserrat-Bold",
        fontSize: CGFloat = 16,
        indicatorImage: String = "indicator_placeholder",
        baseAnimDuration: Double = 0.5

    var textContainer: UIView,
        imageViewContainer: UIView,
        leftImageView: UIImageView,
        rightImageView: UIImageView,
        indicator: UIImageView

    var model: StorySequence,
        currentStep: Int

    var imgNear: CGFloat,
        imgMid: CGFloat,
        imgFar: CGFloat

    var soundPlayer: SoundPlayer = SoundPlayer()

    private var canTap: Bool
    private var lastImages: Array<String?> = [nil, nil]
    private var lastPositions: Array<StorySequence.ImagePosition> = [.hidden, .hidden]

    /**
     For easy access to accessibility identifiers used in testing.
     */
    enum AccessibilityIdentifiers: String {
        case storySequencePlayer = "story-sequence-player"
        case skipWarningView = "ssp-skip-warning-view"
        case skipWarningYes = "ssp-skip-warning-view-button-yes"
        case skipWarningNo = "ssp-skip-warning-view-button-no"
    }

    /* *******************************
     MARK: Initializers
     ******************************* */
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    override init(frame: CGRect) {
        self.model = StorySequence(music: nil, [:])
        self.textContainer = UIView(frame: CGRect.zero)
        self.imageViewContainer = UIView(frame: CGRect.zero)
        self.leftImageView = UIImageView(frame: CGRect.zero)
        self.rightImageView = UIImageView(frame: CGRect.zero)
        self.indicator = UIImageView(frame: CGRect.zero)

        self.currentStep = -1
        self.canTap = false

        self.imgNear = 0
        self.imgMid = 0
        self.imgFar = 0

        super.init(frame: frame)

        self.accessibilityIdentifier = AccessibilityIdentifiers.storySequencePlayer.rawValue
        let margin: CGFloat = 10
        let imageViewHeight: CGFloat = 0.6

        addBlur(self, .dark)
        layoutImageViews(margin, imageViewHeight)
        layoutTextContainer(margin, 1 - imageViewHeight)
        addTapGesture()
        addLPGesture()
    }

    convenience init(delegate: StorySequencePlayerDelegate, model: StorySequence, firstTime: Bool) {
        self.init(frame: UIScreen.main.bounds)

        self.delegate = delegate
        self.model = model
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.baseAnimDuration) {
                self.checkCurrentStep()
                let soundFile = self.model.music
                guard let sound = soundFile else { return }
                self.soundPlayer.numberOfLoops = -1
                self.soundPlayer.playSound(sound, 0.1)
            }
        }

        if firstTime == false {
            showSkipNotice()
        }
    }

    /**
     Automatically start the sequence when StorySequencePlayer is added to the view hierarchy.
     */
    override func didMoveToSuperview() {
        self.delegate?.sequenceDidStart(sender: self)
    }

    /**
     Show a notice letting users know that long-pressing will start the skip sequence.
     */
    private func showSkipNotice() {
        let label = UILabel(frame: CGRect(x: 5, y: 5, width: self.bounds.width, height: 0))
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont(name: fontName, size: fontSize)

        label.text = "(Press and hold to skip)"

        label.sizeToFit()

        let view = Animate(label)
        view.wait(asec: 1.5, then: {
            self.addSubview(label)
            view.fadeIn(then: {
                view.setDuration(4).fade(to: 0.2)
                view.wait(asec: 1.5, then: {
                    view.setDuration(view.originalDuration).move(to: [-self.bounds.width * 2, 0], then: {
                        label.removeFromSuperview()
                    })
                })
            })
        })
    }

    /* *******************************
     MARK: Private Class Functions
     ******************************* */
    /**
     Add a full screen blurred view as the background layer.

     - Parameter view: Target `UIView`.
     - Parameter style: Desired `UIBlueEffectStyle`.
     */
    private func addBlur(_ view: UIView, _ style: UIBlurEffectStyle) {
        let blur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurView)
    }

    /**
     Test for iPhone X to be able to adjust for the black area in the larger status bar.

     - Returns: `true` if the user device is a phone with pixel height 2436.
     */
    private func isIphoneX() -> Bool {
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            return true
        }
        return false
    }

    /**
     - Returns: 44 pixels.
     */
    private func iPhoneXStatusBarHeight() -> CGFloat {
        return 44
    }

    /**
     Layout the image container in the main view, layout the imageviews in the image container, also add the indicator view

     - Parameter margin: The margin to pad either side of the container.
     - Parameter height: The intended height of the image containers.
     */
    private func layoutImageViews(_ margin: CGFloat, _ height: CGFloat) {

        let containerW = self.bounds.width - (margin * 2)
        let containerH = self.bounds.height * height
        let adjustedW = isIphoneX() ? containerW - iPhoneXStatusBarHeight(): containerW

        imageViewContainer.frame = CGRect(x: margin, y: self.bounds.height - containerH, width: adjustedW, height: containerH)

        let bounds = imageViewContainer.bounds
        let imageWidth: CGFloat = bounds.width * 0.3
        let imageHeight: CGFloat = bounds.height

        let leftRect = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        let rightRect = CGRect(x: bounds.width - imageWidth, y: 0, width: imageWidth, height: imageHeight)

        leftImageView.frame = leftRect
        rightImageView.frame = rightRect

        leftImageView.contentMode = .scaleAspectFit
        rightImageView.contentMode = .scaleAspectFit

        leftImageView.isOpaque = true
        rightImageView.isOpaque = true

        imgMid = (imageViewContainer.bounds.width / 4) - (imageWidth / 2)
        imgFar = (imageViewContainer.bounds.width / 2) - imageWidth

        moveImage(pos: .hidden, view: leftImageView, left: true, dur: baseAnimDuration)
        moveImage(pos: .hidden, view: rightImageView, left: false, dur: baseAnimDuration)

        let indicatorSize = 15
        indicator.frame = CGRect(x: 0, y: 0, width: indicatorSize, height: indicatorSize)
        indicator.contentMode = .scaleAspectFit
        indicator.image = UIImage(named: indicatorImage)
        indicator.center = CGPoint(x: (self.bounds.width / 2), y: self.bounds.height - indicator.frame.height)
        hideIndicator()

        imageViewContainer.addSubview(leftImageView)
        imageViewContainer.addSubview(rightImageView)
        self.addSubview(imageViewContainer)
        self.addSubview(indicator)
    }

    /**
     Layout the main text container. Parent container for the left and right text containers.

     - Parameter margin: The margin to pad either side of the container.
     - Parameter height: The intended height of the text containers.
     */
    private func layoutTextContainer(_ margin: CGFloat, _ height: CGFloat) {

        let containerW = self.bounds.width - (margin * 2)
        let containerH = (self.bounds.height * height) - (margin * 2)
        let adjustedW = isIphoneX() ? containerW - iPhoneXStatusBarHeight(): containerW

        textContainer.frame = CGRect(x: margin, y: margin, width: adjustedW, height: containerH)
        textContainer.layer.masksToBounds = true
        textContainer.layer.cornerRadius = 12

        self.addSubview(textContainer)
    }

    /**
    Add a tap gesture to manually step through the story sequence.
     */
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapView(_:)))
        self.addGestureRecognizer(tap)
    }

    /**
     Check if the view is tappable. If so, call `checkCurrentStep()`.
     */
    @objc private func tapView(_ sender: UITapGestureRecognizer) {
        if canTap {
            checkCurrentStep()
        }
    }

    /**
     Add a long press gesture to skip the story sequence.
     */
    private func addLPGesture() {
        let lp = UILongPressGestureRecognizer(target: self, action: #selector(self.lpView(_:)))
        self.addGestureRecognizer(lp)
    }

    /**
     Check if a long press has begun. If so, call `displaySkipWarning()`.
     */
    @objc private func lpView(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            displaySkipWarning()
        }
    }

    /**
     Create and display an interactive warning view. User must ascert their intention to skip the story sequence.
    */
    private func displaySkipWarning() {
        let view = UIView(frame: self.bounds)
        view.accessibilityIdentifier = AccessibilityIdentifiers.skipWarningView.rawValue

        let warningView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height / 2))
        warningView.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)

        if #available(iOS 10.0, *) {
            addBlur(view, .prominent)
            addBlur(warningView, .prominent)
        } else {
            addBlur(view, .extraLight)
            addBlur(warningView, .extraLight)
        }

        let bounds = warningView.bounds
        let topContainer = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height / 2))
        let botContainer = UIView(frame: CGRect(x: 0, y: bounds.height / 2, width: bounds.width, height: bounds.height / 2))

        let label = UILabel(frame: topContainer.bounds)
        label.font = UIFont(name: fontName, size: fontSize * 2)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Ready to skip?"

        let botBounds = botContainer.bounds
        let yes = UIButton(frame: CGRect(x: 0, y: 0, width: botBounds.width / 2, height: botBounds.height))
        yes.accessibilityIdentifier = AccessibilityIdentifiers.skipWarningYes.rawValue
        yes.addTarget(self, action: #selector(tapSkipButton(_:)), for: .touchUpInside)
        yes.setTitle("Yes", for: .normal)
        yes.tag = 1

        let no = UIButton(frame: CGRect(x: botBounds.width / 2, y: 0, width: botBounds.width / 2, height: botBounds.height))
        no.accessibilityIdentifier = AccessibilityIdentifiers.skipWarningNo.rawValue
        no.addTarget(self, action: #selector(tapSkipButton(_:)), for: .touchUpInside)
        no.setTitle("No", for: .normal)

        topContainer.addSubview(label)
        botContainer.addSubview(yes)
        botContainer.addSubview(no)
        warningView.addSubview(topContainer)
        warningView.addSubview(botContainer)
        view.addSubview(warningView)
        self.addSubview(view)

        let dur = 0.05
        Animate(view, dur).fadeIn()
    }

    /**
     Called when from the warning view shown by `displaySkipWarning()`. Either dismiss the warning, or proceed with skipping the story sequence.

     Skipping dismisses and releases the view, and calls the delegate method `sequenceWasSkipped(sender:)`.
     */
    @objc private func tapSkipButton(_ sender: UIButton?) {
        guard let button = sender else { return }
        if button.tag > 0 {
            // cancel the sequence and remove the StorySequencePlayer view
            hide()
            self.delegate?.sequenceWasSkipped(sender: self)
        } else {
            // find and target the warning view for dismissal
            for view in self.subviews {
                if view.accessibilityIdentifier == AccessibilityIdentifiers.skipWarningView.rawValue {
                    let dur = 0.05
                    Animate(view, dur).fade(to: 0, then: {
                        view.removeFromSuperview()
                    })
                }
            }
        }
    }

    /**
     Check if there is another step in the sequence, update own count and call UI updates, else hide and dismiss.

     Called when the view is tapped.
     */
    private func checkCurrentStep() {
        // stop interactions, enabled after updateToCurrentStep is complete
        self.canTap = false
        hideIndicator()

        if currentStep < model.steps.count - 1 {
            currentStep = currentStep + 1
            updateToCurrentStep()
        } else {
            hide()
        }
    }

    /**
     Update the layout for both sides to the `currentStep`. Wait for animations to complete before re-enabling interactions.
     */
    private func updateToCurrentStep() {
        updateLeftSide()
        updateRightSide()

        // wait double the baseAnimDuration plus a little before enabling user interactions again
        let dur = (baseAnimDuration * 2) + 0.1
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + dur) {
                self.canTap = true
                self.showIndicator()
            }
        }
    }

    /**
     Update the layout of the left side to the `currentStep`. Automatically handles all animations and changes based on the data in the model.
     */
    private func updateLeftSide() {

        guard let m = model.steps[currentStep]!.lftEvent else { return }

        // handle text
        if m.text != nil {
            let label = self.makeLabel(text: m.text!, left: true)
            self.textContainer.addSubview(label)
            shiftLabels()
        }

        // set up conditions to determine how to handle swapping a character image
        let swapPosition = m.position != .hidden
        var swapImage = false
        var targetPosition: StorySequence.ImagePosition = .hidden
        var components: Array<String>?

        if m.image != nil {
            components = m.image!.components(separatedBy: "^")
            swapImage = components![0] != lastImages[0]
            if swapPosition {
                if m.position != nil {
                    targetPosition = m.position!
                } else {
                    targetPosition = lastPositions[0]
                }
            }
        }

        // if the character is different, animate it off screen, swap the image, and animate on screen to the appropriate position
        if swapImage && swapPosition {

            moveImage(pos: .hidden, view: leftImageView, left: true, dur: baseAnimDuration / 2)

            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.asyncAfter(deadline: .now() + self.baseAnimDuration / 2) {
                    self.changeImage(imageView: self.leftImageView, image: m.image!)
                    self.moveImage(pos: targetPosition, view: self.leftImageView, left: true, dur: self.baseAnimDuration / 2)
                }
            }

            if m.imgAnim != nil {
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.baseAnimDuration) {
                        self.doAnimation(anim: m.imgAnim!, view: self.leftImageView)
                    }
                }
            }


        } else {

            // otherwise handle the image normally
            if m.image != nil {
                changeImage(imageView: leftImageView, image: m.image!)
            }

            if m.position != nil {
                moveImage(pos: m.position!, view: leftImageView, left: true, dur: baseAnimDuration)
            }

            if m.imgAnim != nil {
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.baseAnimDuration) {
                        self.doAnimation(anim: m.imgAnim!, view: self.leftImageView)
                    }
                }
            }
        }

        // prepare global variables for the next slide
        if m.image != nil {
            lastImages[0] = components![0]
        }
        if m.position != nil {
            lastPositions[0] = m.position!
        }

    }

    /**
     Update the layout of the right side to the `currentStep`. Automatically handles all animations and changes based on the data in the model.
     */
    private func updateRightSide() {

        guard let m = model.steps[currentStep]!.rgtEvent else { return }

        // handle text
        if m.text != nil {
            let label = self.makeLabel(text: m.text!, left: false)
            self.textContainer.addSubview(label)
            shiftLabels()
        }

        // set up conditions to determine how to handle swapping a character image
        let swapPosition = m.position != .hidden
        var swapImage = false
        var targetPosition: StorySequence.ImagePosition = .hidden
        var components: Array<String>?

        if m.image != nil {
            components = m.image!.components(separatedBy: "^")
            swapImage = components![0] != lastImages[1]
            if swapPosition {
                if m.position != nil {
                    targetPosition = m.position!
                } else {
                    targetPosition = lastPositions[1]
                }
            }
        }

        // if the character is different, animate it off screen, swap the image, and animate on screen to the appropriate position
        if swapImage && swapPosition {

            moveImage(pos: .hidden, view: rightImageView, left: false, dur: baseAnimDuration / 2)

            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.asyncAfter(deadline: .now() + self.baseAnimDuration / 2) {
                    self.changeImage(imageView: self.rightImageView, image: m.image!)
                    self.moveImage(pos: targetPosition, view: self.rightImageView, left: false, dur: self.baseAnimDuration / 2)
                }
            }

            if m.imgAnim != nil {
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.baseAnimDuration) {
                        self.doAnimation(anim: m.imgAnim!, view: self.rightImageView)
                    }
                }
            }


        } else {

            // otherwise handle the image normally
            if m.image != nil {
                changeImage(imageView: rightImageView, image: m.image!)
            }

            if m.position != nil {
                moveImage(pos: m.position!, view: rightImageView, left: false, dur: baseAnimDuration)
            }

            if m.imgAnim != nil {
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.baseAnimDuration) {
                        self.doAnimation(anim: m.imgAnim!, view: self.rightImageView)
                    }
                }
            }
        }

        // prepare global variables for the next slide
        if m.image != nil {
            lastImages[1] = components![0]
        }
        if m.position != nil {
            lastPositions[1] = m.position!
        }

    }

    /**
     Create a formatted label to use as unbound text bubbles.

     - Parameter text: The text to be used.
     - Parameter left: If `true`, label is formatted to be used on the left side, otherwise it is formatted for the right side.

     - Returns: A properly formatted `UILabel` ready to be inserted in the view hierarchy.
     */
    private func makeLabel(text: String, left: Bool) -> UILabel {
        // determine properties based on container bounds
        let margin: CGFloat = 10
        let bounds = textContainer.bounds
        let width = (bounds.width - (margin * 4)) / 2
        let height = (bounds.height - (margin * 2)) / 4
        let y = bounds.height - margin
        // determine if it's on the left or right side
        let x = (left) ? margin : bounds.width - width - margin

        let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))

        // set basic properties
        label.textColor = UIColor.white
        label.font = UIFont(name: fontName, size: fontSize)
        label.text = text
        label.textAlignment = (left) ? .left : .right
        label.tag = currentStep

        // resize and reformat to account for word wrapping
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = width
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.sizeToFit()

        // force width back to original value
        label.frame.size.width = width

        return label
    }

    /**
     Handles shifting all of the subviews of `textContainer`.
     */
    private func shiftLabels() {
        // get subviews from the textcontainer
        let labels = textContainer.subviews

        // 50% longer than the baseAnimDuration
        let dur = baseAnimDuration + (baseAnimDuration / 2)
        let fadeTo: Float = 0.2

        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                // if there are labels, get the height of the newly added label and shift all labels by that amount + a buffer
                let buffer: CGFloat = 15
                let height = (labels.count > 0) ? labels.last!.frame.size.height + buffer : 0

                // loop through and shift the labels, reduce alpha for old labels
                for label in labels {
                    // animate moving all labels, use random value to make the spring jiggle more dynamic
                    Animate(label, dur).setSpring(0.6, 6.5 + (self.randomCGFloat() * 8)).setOptions(.curveEaseOut).move(by: [0, -height])

                    // if the label isnt't the new label, and alpha is still 1, then reduce alpha
                    if label.tag != self.currentStep {
                        if label.alpha == 1 {
                            Animate(label, dur).fade(to: fadeTo)
                        }
                    }
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
                        Animate(label, self.baseAnimDuration).fade(to: 0)
                    }
                }
            }
        }
    }

    /**
     Returns a random CGFloat 0 - 1.
     */
    private func randomCGFloat() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }

    /**
     Change the `image` of the `imageView`.

     - Parameter: imageView: Target `UIImageView`.
     - Parameter: image: File name of the image to change to.

     - Remarks: This function originally included animation instructions as well. Even though it's simplified to the point of not really being necessary, it has been left in case animations need to be added again.
     */
    private func changeImage(imageView: UIImageView, image: String) {
        imageView.image = UIImage(named: image)
    }

    // determine x position and animate moving the imageView
    /**
     Determing the horizontal position to move an image to and animate the `imageView` to the position.

     - Parameter pos: `enum StorySequence.ImagePosition` describing the target position.
     - Parameter view: Target `UIImageView`.
     - Parameter left: If `true`, `pos` cases will be calculated for the left side of the view container. Otherwise `pos` will be calculated for the right side.
     - Parameter dur: The duration of the animation. This is variable since this function is used differently depending on whether or not the entire character image or just the character type/mood has changed.
     */
    private func moveImage(pos: StorySequence.ImagePosition, view: UIImageView, left: Bool, dur: Double) {
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
        }

        x = (left) ? x : imageViewContainer.bounds.width - view.bounds.width - x

        let v = Animate(view, dur)
        v.move(to: [x, view.frame.origin.y])
    }

    /**
     Hide the indicator when the view is not interactive.
    */
    private func hideIndicator() {
        indicator.isHidden = true
        blinkIndicator()
    }

    /**
     Show the indicator when the view is interactive.
     */
    private func showIndicator() {
        indicator.isHidden = false
        blinkIndicator()
    }

    /**
     Handle blinking the indicator when visible, or turning off the animation when hidden.
     */
    private func blinkIndicator() {
        let dur = baseAnimDuration + (baseAnimDuration / 2)
        var flash = true
        if indicator.isHidden {
            flash = false
        }
        Animate(indicator, dur).flashing(flash)
    }

    /**
     Handle the animations for an image. This is the animation specific to the step, not the universal animations used when changing position.

     All of the animation instructions are in this function. When designing/adding new animation options, the case and instructions should be added here as well as in `enum StorySequence.ImageAnimation`. New options also need to be synced with the PowerUp Story Designer web app.

     - Parameter anim: `enum StorySequence.ImageAnimation` case for the desired animation. Provided by the model.
     - Parameter view: Target `UIView` to be animated.
     */
    private func doAnimation(anim: StorySequence.ImageAnimation, view: UIView) {
        let duration = 0.4
        let tiltDuration = 0.7
        switch anim {
        case .shake:
            Animate(view, duration).setDelay(baseAnimDuration / 3).shake()
        case .tiltLeft:
            Animate(view, tiltDuration).tilt(degrees: -30)
        case .tiltRight:
            Animate(view, tiltDuration).tilt(degrees: 30)
        case .jiggle:
            Animate(view, duration).jiggle()
        case .flip:
            let v = Animate(view, tiltDuration / 2)
            v.flip(then: {
                v.flip()
            })
        }
    }

    /* *******************************
     MARK: Public Class Methods
     ******************************* */
    /**
     Handles hiding and dismissing the `StorySequencePlayer` view.

     Ends sound, animates the view to hidden, and removes this instance of `StorySequencePlayer` from its superview.

     Also calls the delegate method `sequenceDidFinish(sender:)`.
     */
    func hide() {
        if #available(iOS 10.0, *) {
            soundPlayer.player?.setVolume(0, fadeDuration: baseAnimDuration)
        }
        let v = Animate(self, baseAnimDuration)
        v.fade(to: 0, then: {
            self.soundPlayer.player?.stop()
            self.delegate?.sequenceDidFinish(sender: self)
            self.removeFromSuperview()
        })
    }

}

/* *******************************
 MARK: Delegate Methods
 ******************************* */
protocol StorySequencePlayerDelegate: AnyObject {
    /**
     Called when `StorySequencePlayer` is added to the view hierarchy.
     */
    func sequenceDidStart(sender: StorySequencePlayer)
    /**
     Called when `StorySequencePlayer` is dismissed, whether via skip or natural completion.
     */
    func sequenceDidFinish(sender: StorySequencePlayer)
    /**
     Called when `StorySequencePlayer` is skipped.
     */
    func sequenceWasSkipped(sender: StorySequencePlayer)
}
