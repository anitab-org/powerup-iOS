import UIKit

/**
 Class for creating animations. Chains together animation 'sentences' using self-returning functions and completion handlers.

 ```
 Animate(view, duration).setOptions(.curveLinear).rotate(to: 90)
 ```
 ```
 let view = Animate(view, duration)
 view.setSpring(damping, velocity).translate(by: [50, 0], then: {
     view.flip().shake(then: {
        view.reset()
     })
 })
 ```

 - Author: Cadence Holmes 2018
 */
class Animate {
    typealias Completion = () -> ()

    /* *******************************
     MARK: Init
     ******************************* */
    private var duration: Double,
        options: UIViewAnimationOptions = [.curveEaseOut],
        delay: Double = 0,
        damping: CGFloat = 1,
        velocity: CGFloat = 1,
        dur: Double,
        moved: Bool = false

    var originalDuration: Double

    private var origin: Array<CGFloat>,
        opacity: Float,
        view: UIView

    init(_ view: UIView, _ duration: Double? = nil) {
        self.view = view
        self.origin = [view.frame.origin.x, view.frame.origin.y]
        self.opacity = view.layer.opacity
        self.originalDuration = (duration != nil) ? duration! : 0.5
        self.duration = self.originalDuration
        self.dur = self.originalDuration
    }

    /* *******************************
     MARK: Utility
     ******************************* */

    /**
     Set the options for all animations.

     See `UIView.animate(options: UIViewAnimationOptions)` for more information.
     */
    @discardableResult func setOptions(_ options: UIViewAnimationOptions) -> Animate {
        self.options = options
        return self
    }

    /**
     Set the spring damping and velocity for all animations.

     See `UIView.animate(usingSpringWithDamping:)` and `UIView.animate(initialSpringVelocity:)` for more information.
     */
    @discardableResult func setSpring(_ damping: CGFloat, _ velocity: CGFloat) -> Animate {
        self.damping = damping
        self.velocity = velocity
        return self
    }

    /**
     Set the delay for all animations.
     */
    @discardableResult func setDelay(_ delay: Double) -> Animate {
        self.delay = delay
        return self
    }

    /**
     Set the duration for all animations.
     */
    @discardableResult func setDuration(_ duration: Double) -> Animate {
        self.duration = duration
        self.dur = duration
        return self
    }

    /**
     Convenience function that sets animation durations to `0` (instant).
     */
    @discardableResult func now() -> Animate {
        self.dur = 0
        return self
    }

    /**
     Convenience function that sets animation durations to back to the last set duration.
     */
    @discardableResult func notnow() -> Animate {
        self.dur = self.duration
        return self
    }

    /**
     Cancel current animations on the view layer. The transform does not reset.

     - parameters:
         - then: Nullable completion handler, executed after the duration of the animation.
     */
    @discardableResult func cancel(then: Completion? = nil) -> Animate {
        let t = view.layer.presentation()?.transform
        view.layer.removeAllAnimations()
        if t != nil {
            view.layer.transform = t!
        }
        then?()
        return self
    }

    /**
     Chainable wait function.

     - parameters:
         - asec: Time in seconds to wait.
         - then: Nullable completion handler, executed after the duration of the animation.
     */
    @discardableResult func wait(asec: Double, then: Completion?) -> Animate {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + asec) {
                then?()
            }
        }
        return self
    }

    /* *******************************
     MARK: Compounded
     ******************************* */

    /**
     Tilt animation. Tilt in one direction, then tilt back to origin.

     - parameters:
        - degrees: Amount to tilt. Positive or negative determines direction.
        - then: Nullable completion handler, executed after the duration of the animation.
     */
    @discardableResult func tilt(degrees: Double, then: Completion? = nil) -> Animate {
        let vw = Animate(view, dur / 2).setOptions(options).setSpring(damping, velocity)
        vw.rotate(by: degrees, then: {
            vw.rotate(by: -degrees)
        })
        return self
    }

    /**
     Shaking animation.

     - parameters:
        - vertical: If `true`, the animation will be a vertical shake, else it will be a horizontal shake. Default `false`.
            - keys: An array describing points to move to along a single axis in reference to the origin. Passing `nil` to this parameter will use the default `[10, -10, 7, -7, 4, -4, 1, -1]`.
            - then: Nullable completion handler, executed after the duration of the animation.

     - Important: Uses `Animate().translate`, so be aware if applying this animation along with an `Animate().rotate` transform.
     */
    @discardableResult func shake(vertical: Bool? = nil, keys: Array<Double>? = nil, then: Completion? = nil) -> Animate {
        // check if it's vertical or horizontal, guard against nil
        let v: Bool = (vertical != nil) ? vertical! : false
        // in the key array, target positions are calculated in reference to the origin
        // so the default array would read as:
        // move to origin+10, then origin-10, then origin+7, etc.
        let k: Array<Double> = (keys != nil) ? keys! : [10, -10, 7, -7, 4, -4, 1, -1]
        // get the duration of a single animation event
        let oneDur: Double = duration / (Double(k.count) + 1)
        // queue the animation to adhere to the expected delay on the calling class instance
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                // loop through keys, apply delay and animate each in turn, finally reset to original relative position
                for i in 0..<k.count + 1 {
                    let del: Double = oneDur * Double(i + 1)
                    var a: CGFloat, b: CGFloat
                    // for each key, calculate the amount to move in relation to the previous key
                    if i < k.count {
                        a = (!v) ? CGFloat(k[i]) : 0
                        b = (v) ? CGFloat(k[i]) : 0
                        if i > 0 {
                            if !v {
                                a = a - CGFloat(k[i - 1])
                            } else {
                                b = b - CGFloat(k[i - 1])
                            }
                        }
                    } else {
                        // or if all of the keys have been used, offset the last key to return to the original relative position
                        let last = CGFloat(k.last!)
                        let end = last - last
                        a = (!v) ? end : 0
                        b = (v) ? end : 0
                    }
                    let vw = Animate(self.view, oneDur).setOptions(self.options).setSpring(self.damping, self.velocity)
                    vw.setDelay(del).translate(by: [a, b], then: {
                        if i == k.count {
                            then?()
                        }
                    })
                }
            }
        }
        return self
    }

    /**
     Jiggle animation.

     - parameters:
         - amount: The maximum size to which the view can be jiggled. Default `1.08`.
         - times: The number of times the view should jiggle. Default `7`.
         - then: Nullable completion handler, executed after the duration of the animation.
     */
    @discardableResult func jiggle(_ amount: Double = 1.08, _ times: Int = 7, then: Completion? = nil) -> Animate {
        let realTimes = times / 2
        let n = Double(times)
        let oneDur = dur / n
        var array: Array<CGFloat> = []
        // fill the array with alternating inverse values that get progressively smaller
        for i in 0..<realTimes {
            let z = (amount * n) - ((amount / n) * Double(i))
            let a = CGFloat(z / n)
            let b = CGFloat(n / z)
            array.append(a)
            array.append(b)
        }
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.dur) {
                // loop through the array and animate scale for each value
                for i in 0..<array.count {
                    let val: CGFloat = array[i]
                    let vw = Animate(self.view, oneDur).setOptions(self.options).setSpring(self.damping, self.velocity)
                    vw.setDelay(oneDur * Double(i)).scale(by: CGFloat(val), then: {
                        then?()
                    })
                }
            }
        }
        return self
    }

    /**


     - parameters:
        - then: Nullable completion handler, executed after the duration of the animation.
     */
    @discardableResult func fadeIn(then: Completion? = nil) -> Animate {
        view.layer.opacity = 0
        let vw = Animate(view, dur).setOptions(options).setSpring(damping, velocity).setDelay(delay)
        vw.fade(to: 1, then: { then?() })
        return self
    }

    /**
     Shrink and fade the view to a scale that's near invisible.

     - parameters:
        - then: Nullable completion handler, executed after the duration of the animation.
     */
    @discardableResult func shrinkAndWink(then: Completion? = nil) -> Animate {
        let vw = Animate(view, dur).setOptions(options).setSpring(damping, velocity).setDelay(delay)
        vw.fade(to: 0).scale(by: 0.01, then: { then?() })
        return self
    }

    /**
     Set the view to a scale and opacity that's near invisible, then grow to full size.

     - parameters:
        - then: Nullable completion handler, executed after the duration of the animation.
     */
    @discardableResult func growAndShow(then: Completion? = nil) -> Animate {
        view.layer.opacity = 0
        let vw = Animate(view, dur).setOptions(options).setSpring(damping, velocity)
        vw.now().scale(by: 0.01, then: {
            vw.notnow().wait(asec: self.delay, then: {
                vw.fade(to: 1).scale(by: 1 / 0.01, then: { then?() })
            })
        })
        return self
    }

    /**
     Flashing

     - parameters:
        - then: Nullable completion handler, executed after the duration of the animation.

     not compatible with .now() since it's a repeating animation
     */
    @discardableResult func flashing(_ on: Bool) -> Animate {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                let animation = CABasicAnimation(keyPath: "opacity")
                animation.duration = self.duration
                animation.fromValue = self.view.layer.opacity

                if on {
                    animation.toValue = abs(1 - self.view.layer.opacity)
                    animation.repeatCount = .infinity
                    animation.autoreverses = true
                } else {
                    animation.toValue = self.opacity
                    animation.isRemovedOnCompletion = true
                }

                self.view.layer.add(animation, forKey: "opacity")
            }
        }
        return self
    }

    /* *******************************
     MARK: Simple Animations
     ******************************* */

    /* *******************************
     MARK: Fade
     ******************************* */
    /**
     Change the view layer opacity **to** a percentage.

     - parameters:
        - to: Fade the view layer opacity to this percentage.
        - then: Nullable completion handler, executed after the duration of the animation.
     */
    @discardableResult func fade(to: Float, then: Completion? = nil) -> Animate {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.dur,
                               delay: self.delay,
                               usingSpringWithDamping: self.damping,
                               initialSpringVelocity: self.velocity,
                               options: self.options,
                               animations: { [weak self] in
                                   guard let this = self else { return }
                                   this.view.layer.opacity = to
                               }, completion: { (finished: Bool) in
                                   then?()
                               })
            }
        }
        return self
    }

    /**
     Change the view layer opacity **by** a percentage. (e.g. If the current opacity is 0.5, `.fade(by:0.5)` will change the opacity to `0.25` or `0.5 * 0.5`)

     - parameters:
        - by: Fade the view layer opacity **by** this percentage.
        - then: Nullable completion handler, executed after the duration of the animation.

     - Important: Requires the view opacity to be `> 0`.
     */
    @discardableResult func fade(by: Float, then: Completion? = nil) -> Animate {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.dur,
                               delay: self.delay,
                               usingSpringWithDamping: self.damping,
                               initialSpringVelocity: self.velocity,
                               options: self.options,
                               animations: { [weak self] in
                                   guard let this = self else { return }
                                   let opac = this.view.layer.opacity
                                   this.view.layer.opacity = opac * by
                               }, completion: { (finished: Bool) in
                                   then?()
                               })
            }
        }
        return self
    }

    /* *******************************
     MARK: Flip
     ******************************* */
    /**
     2D Flip animation.

     - parameters:
        - vertical: If `true`, the animation will be a vertical flip, else it will be a horizontal flip. Default `false`.
        - then: Nullable completion handler, executed after the duration of the animation.
     */
    @discardableResult func flip(vertical: Bool? = nil, then: Completion? = nil) -> Animate {
        let v: Bool = (vertical != nil) ? vertical! : false
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.dur,
                               delay: self.delay,
                               usingSpringWithDamping: self.damping,
                               initialSpringVelocity: self.velocity,
                               options: self.options,
                               animations: { [weak self] in
                                   guard let this = self else { return }
                                   let a: CGFloat = (!v) ? -1 : 1
                                   let b: CGFloat = (v) ? -1 : 1
                                   let t = CATransform3DScale(this.view.layer.transform, a, b, 1)
                                   this.view.layer.transform = t
                               }, completion: { (finished: Bool) in
                                   then?()
                               })
            }
        }
        return self
    }

    /* *******************************
     MARK: Move
     ******************************* */
    /**
     Move the view origin **to point [x, y]** in the superviews space.

     - parameters:
         - to: An array consisting of two `CGFloat`, ordered as `[x, y]`. This is the point to which the origin is moved. This functions differently from `.translate(to:)`.
         - then: Nullable completion handler, executed after the duration of the animation.

     This animation is different from `.translate(to:)`. It moves the origin of the view **frame**.
     */
    @discardableResult func move(to: Array<CGFloat>, then: Completion? = nil) -> Animate {
        if !moved {
            moved = true
        }
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.dur,
                               delay: self.delay,
                               usingSpringWithDamping: self.damping,
                               initialSpringVelocity: self.velocity,
                               options: self.options,
                               animations: { [weak self] in
                                   guard let this = self else { return }
                                   let x = to[0]
                                   let y = to[1]
                                   this.view.frame.origin = CGPoint(x: x, y: y)
                               }, completion: { (finished: Bool) in
                                   then?()
                               })
            }
        }
        return self
    }

    /**
     Move the view origin **by this amount [x, y]** in relation to the current view origin.

     - parameters:
         - by: An array consisting of two `CGFloat`, ordered as `[x, y]`. This is the amount by which the origin is moved.
         - then: Nullable completion handler, executed after the duration of the animation.

     This animation is different from `.translate(by:)`. It moves the origin of the view **frame**.
     */
    @discardableResult func move(by: Array<CGFloat>, then: Completion? = nil) -> Animate {
        if !moved {
            moved = true
        }
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.dur,
                               delay: self.delay,
                               usingSpringWithDamping: self.damping,
                               initialSpringVelocity: self.velocity,
                               options: self.options,
                               animations: { [weak self] in
                                   guard let this = self else { return }
                                   let x = by[0] + this.view.frame.origin.x
                                   let y = by[1] + this.view.frame.origin.y
                                   this.view.frame.origin = CGPoint(x: x, y: y)
                               }, completion: { (finished: Bool) in
                                   then?()
                               })
            }
        }
        return self
    }

    /**
     Move the view center **to point [x, y]** in the superviews space.

     - parameters:
        - to: An array consisting of two `CGFloat`, ordered as `[x, y]`. This is the point to which the center is moved. This functions differently from `.translate(to:)`.
        - then: Nullable completion handler, executed after the duration of the animation.

     This animation is different from `.translate(to:)`. It moves the center of the view **frame**.
     */
    @discardableResult func move(center to: Array<CGFloat>, then: Completion? = nil) -> Animate {
        if !moved {
            moved = true
        }
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.dur,
                               delay: self.delay,
                               usingSpringWithDamping: self.damping,
                               initialSpringVelocity: self.velocity,
                               options: self.options,
                               animations: { [weak self] in
                                   guard let this = self else { return }
                                   let x = to[0]
                                   let y = to[1]
                                   this.view.center = CGPoint(x: x, y: y)
                               }, completion: { (finished: Bool) in
                                   then?()
                               })
            }
        }
        return self
    }

    /* *******************************
     MARK: Translate
     ******************************* */

    /**
     Translate the view layer **to point [x, y]** in relation to the layer origin.

     This will reset all other transforms on the layer.

     - parameters:
         - to: An array consisting of two `CGFloat`, ordered as `[x, y]`. This represents a point in relation to the view layers origin **to which** the layer is translated. This functions differently from `.move(to:)`.
         - then: Nullable completion handler, executed after the duration of the animation.

     This animation is different from `.move(to:)`. It is a transform on the view layer and does not change the actual frame location.

     - Important: `.translate` does not work as you might expect when combined with `.rotate` transform. Use `.move(by:)` if you need to chain animations that move and rotate.
     */
    @discardableResult func translate(to: Array<CGFloat>, then: Completion? = nil) -> Animate {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.dur,
                               delay: self.delay,
                               usingSpringWithDamping: self.damping,
                               initialSpringVelocity: self.velocity,
                               options: self.options,
                               animations: { [weak self] in
                                   guard let this = self else { return }
                                   let x = to[0]
                                   let y = to[1]
                                   let t = CATransform3DMakeTranslation(x, y, 0)
                                   this.view.layer.transform = t
                               }, completion: { (finished: Bool) in
                                   then?()
                               })
            }
        }
        return self
    }

    /**
     Translate the view layer **by [x, y] amount** in relation to the layers current position.

     - parameters:
         - by: An array consisting of two `CGFloat`, ordered as `[x, y]`. This represents a point in relation to the view layers origin to which the layer is translated.
         - then: Nullable completion handler, executed after the duration of the animation.

     This animation is different from `.move(by:)`. It is a transform on the view layer and does not change the actual frame location.

     - Important: `.translate` does not work as you might expect when combined with `.rotate` transform. Use `.move(by:)` if you need to chain animations that move and rotate.
     */
    @discardableResult func translate(by: Array<CGFloat>, then: Completion? = nil) -> Animate {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.dur,
                               delay: self.delay,
                               usingSpringWithDamping: self.damping,
                               initialSpringVelocity: self.velocity,
                               options: self.options,
                               animations: { [weak self] in
                                   guard let this = self else { return }
                                   let x = by[0]
                                   let y = by[1]
                                   let t = CATransform3DTranslate(this.view.layer.transform, x, y, 0)
                                   this.view.layer.transform = t
                               }, completion: { (finished: Bool) in
                                   then?()
                               })
            }
        }
        return self
    }

    /* *******************************
     MARK: Scale
     ******************************* */
    /**
     Uniformly scale the view layer **to an amount** in relation to its original size.

     Using this animation will reset any other transforms.

     - parameters:
         - to: Amount to which the view layer is scaled. `1.0` will always be the original size.
         - then: Nullable completion handler, executed after the duration of the animation.

     - Important: `.scale(to:)` values are in relation to the original scale. `.scale(to: 1.5)` would scale a view to 150% its original size, and `.scale(to: 1)` would then scale it back to it's original size.
     */
    @discardableResult func scale(to: CGFloat, then: Completion? = nil) -> Animate {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.dur,
                               delay: self.delay,
                               usingSpringWithDamping: self.damping,
                               initialSpringVelocity: self.velocity,
                               options: self.options,
                               animations: { [weak self] in
                                   guard let this = self else { return }
                                   let t = CATransform3DMakeScale(to, to, 1)
                                   this.view.layer.transform = t
                               }, completion: { (finished: Bool) in
                                   then?()
                               })
            }
        }
        return self
    }

    /**
     Uniformly scale the view layer **by an amount** in relation to its current transform.

     - parameters:
         - by: Amount by which the view layer is scaled. `1.0` will always be no change.
         - then: Nullable completion handler, executed after the duration of the animation.

     - Important: `.scale(by:)` values are in relation to the current scale, which is always represented as `1.0`. If you scale to `1.5`, then try to scale to `1.0` there would be no change. To more easily calculate values for `.scale(by:)`, you could use fractions instead of decimals. Scale to `3/2` to increase size by 50%, then scale to `2/3` to get back to the original size.
     */
    @discardableResult func scale(by: CGFloat, then: Completion? = nil) -> Animate {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.dur,
                               delay: self.delay,
                               usingSpringWithDamping: self.damping,
                               initialSpringVelocity: self.velocity,
                               options: self.options,
                               animations: { [weak self] in
                                   guard let this = self else { return }
                                   let t = CATransform3DScale(this.view.layer.transform, by, by, 1)
                                   this.view.layer.transform = t
                               }, completion: { (finished: Bool) in
                                   then?()
                               })
            }
        }
        return self
    }

    /* *******************************
     MARK: Rotate
     ******************************* */
    /**
     Rotate the view layer around its center point, **to an angle in degrees** in relation to its origin.

     Using this animation will reset any other transforms.

     - parameters:
         - to: Rotate the view layer to this angle in degrees. Positive or negative determines direction.
         - then: Nullable completion handler, executed after the duration of the animation.

     - Important: `.translate` does not work as you might expect when combined with `.rotate` transform. Use `.move(by:)` if you need to chain animations that move and rotate.
     */
    @discardableResult func rotate(to: Double, then: Completion? = nil) -> Animate {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.dur,
                               delay: self.delay,
                               usingSpringWithDamping: self.damping,
                               initialSpringVelocity: self.velocity,
                               options: self.options,
                               animations: { [weak self] in
                                   guard let this = self else { return }
                                   let radians = CGFloat(to * Double.pi / 180)
                                   let t = CATransform3DMakeRotation(radians, 0, 0, 1)
                                   this.view.layer.transform = t
                               }, completion: { (finished: Bool) in
                                   then?()
                               })
            }
        }
        return self
    }

    /**
     Rotate the view layer around its center point, **by an amount in degrees** in relation to its current transform.

     - parameters:
         - by: Rotate the view layer by this amount in degrees. Positive or negative determines direction.
         - then: Nullable completion handler, executed after the duration of the animation.

     - Important: `.translate` does not work as you might expect when combined with `.rotate` transform. Use `.move(by:)` if you need to chain animations that move and rotate.
     */
    @discardableResult func rotate(by: Double, then: Completion? = nil) -> Animate {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.dur,
                               delay: self.delay,
                               usingSpringWithDamping: self.damping,
                               initialSpringVelocity: self.velocity,
                               options: self.options,
                               animations: { [weak self] in
                                   guard let this = self else { return }
                                   let radians = CGFloat(by * Double.pi / 180)
                                   let t = CATransform3DRotate(this.view.layer.transform, radians, 0, 0, 1)
                                   this.view.layer.transform = t
                               }, completion: { (finished: Bool) in
                                   then?()
                               })
            }
        }
        return self
    }

    /* *******************************
     MARK: Invert
     ******************************* */
    /**
     Invert the view layers current transform. No change if the transform is already its identity.

     - parameters:
        - then: Nullable completion handler, executed after the duration of the animation.
     */
    @discardableResult func invert(then: Completion? = nil) -> Animate {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.dur,
                               delay: self.delay,
                               usingSpringWithDamping: self.damping,
                               initialSpringVelocity: self.velocity,
                               options: self.options,
                               animations: { [weak self] in
                                   guard let this = self else { return }
                                   this.view.layer.transform = CATransform3DInvert(this.view.layer.transform)
                               }, completion: { (finished: Bool) in
                                   then?()
                               })
            }
        }
        return self
    }

    /* *******************************
     MARK: Reset
     ******************************* */
    /**
     Animates the view layer and frame back to its original state.

     - parameters:
        - then: Nullable completion handler, executed after the duration of the animation.
     */
    @discardableResult func reset(then: Completion? = nil) -> Animate {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.dur,
                               delay: self.delay,
                               usingSpringWithDamping: self.damping,
                               initialSpringVelocity: self.velocity,
                               options: self.options,
                               animations: { [weak self] in
                                   guard let this = self else { return }
                                   this.view.layer.opacity = this.opacity
                                   this.view.layer.transform = CATransform3DIdentity
                                   if this.moved {
                                       this.move(to: this.origin)
                                       this.moved = false
                                   }
                               }, completion: { (finished: Bool) in
                                   then?()
                               })
            }
        }
        return self
    }

}
