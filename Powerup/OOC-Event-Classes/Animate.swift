import UIKit

/**
 Class for creating animations. It's designed so you can chain together animation 'sentences' using self-returning functions and completion handlers.
 
  - Author: Cadence Holmes
 
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

 More detailed information coming.
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
        moved: Bool = false,
        dur: Double

    private let view: UIView,
        origin: Array<CGFloat>

    init(_ view: UIView, _ duration: Double? = nil) {
        self.view = view
        self.origin = [view.center.x, view.center.y]
        self.duration = (duration != nil) ? duration! : 0.5
        self.dur = self.duration
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
    @discardableResult func cancel(then: Completion?) -> Animate {
        let t = self.view.layer.presentation()?.transform
        self.view.layer.removeAllAnimations()
        if t != nil {
            self.view.layer.transform = t!
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
                               animations: {
                                   self.view.layer.transform = CATransform3DInvert(self.view.layer.transform)
                               }, completion: { (finished: Bool) in
                                   then?()
                               })
            }
        }
        return self
    }

    /**
     Tilt animation. Tilt in one direction with a slight vertical offset, then tilt back to origin.

     - parameters:
        - degrees: Amount to tilt. Positive or negative determines direction.
        - then: Nullable completion handler, executed after the duration of the animation.
     */
    @discardableResult func tilt(degrees: Double, then: (() -> ())? = nil) -> Animate {
        let view = Animate(self.view, dur / 2)
        view.move(by: [0, 10]).rotate(by: degrees, then: {
            view.move(by: [0, -10]).rotate(by: -degrees, then: {
                then?()
            })
        })
        return self
    }

    /**
     Shaking animation.
     
     - parameters:
        - vertical: If `true`, the animation will be a vertical shake, else it will be a horizontal shake. Default `false`.
            - keys: An array describing points to move to along a single axis in reference to the origin. Passing `nil` to this parameter will use a default shake animation.
            - then: Nullable completion handler, executed after the duration of the animation.
     
     - Important: Uses `Animate().translate`, so be aware if applying this animation along with an `Animate().rotate` transform.
     
     
     not affected by now()
     */
    @discardableResult func shake(vertical: Bool? = nil, keys: Array<Double>? = nil, then: (() -> ())? = nil) -> Animate {
        // check if it's vertical or horizontal, guard against nil
        let v: Bool = (vertical != nil) ? vertical! : false
        // in the key array, target positions are calculated in reference to the origin
        // so the default array would read as:
        // move to origin+10, then origin-10, then origin+7, etc.
        let k: Array<Double> = (keys != nil) ? keys! : [10, -10, 7, -7, 4, -4, 1, -1]
        // get the duration of a single animation event
        let oneDur: Double = self.duration / (Double(k.count) + 1)
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
            Animate(self.view, oneDur).setDelay(del).translate(by: [a, b], then: {
                if i == k.count {
                    then?()
                }
            })
        }
        return self
    }

    /**
     Flip animation.
     
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
                               animations: {
                                   let a: CGFloat = (!v) ? -1 : 1
                                   let b: CGFloat = (v) ? -1 : 1
                                   let t = CATransform3DScale(self.view.layer.transform, a, b, 1)
                                   self.view.layer.transform = t
                               }, completion: { (finished: Bool) in
                                   then?()
                               })
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
        // loop through the array and animate scale for each value
        for i in 0..<array.count {
            let val: CGFloat = array[i]
            Animate(view, oneDur).setDelay(oneDur * Double(i)).scale(by: CGFloat(val), then: {
                then?()
            })
        }
        return self
    }

    /* *******************************
     MARK: Move
     ******************************* */
    /**
     Move the view center **to point [x, y]** in the superviews space.
     
     - parameters:
         - to: An array consisting of two `CGFloat`, ordered as `[x, y]`. This is the point to which the center is moved. This functions differently from `.translate(to:)`.
         - then: Nullable completion handler, executed after the duration of the animation.
     
     This animation is different from `.translate(to:)`. It moves the center of the view frame.
     */
    @discardableResult func move(to: Array<CGFloat>, then: Completion? = nil) -> Animate {
        if !moved { moved = true }
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.dur,
                               delay: self.delay,
                               usingSpringWithDamping: self.damping,
                               initialSpringVelocity: self.velocity,
                               options: self.options,
                               animations: {
                                   let x = to[0]
                                   let y = to[1]
                                   self.view.center = CGPoint(x: x, y: y)
                               }, completion: { (finished: Bool) in
                                   then?()
                               })
            }
        }
        return self
    }

    /**
     Move the view center **by this amount [x, y]** in relation to the current view center.
     
     - parameters:
         - by: An array consisting of two `CGFloat`, ordered as `[x, y]`. This is the amount by which the center is moved.
         - then: Nullable completion handler, executed after the duration of the animation.
     
     This animation is different from `.translate(by:)`. It moves the center of the view frame.
     */
    @discardableResult func move(by: Array<CGFloat>, then: Completion? = nil) -> Animate {
        if !moved { moved = true }
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.dur,
                               delay: self.delay,
                               usingSpringWithDamping: self.damping,
                               initialSpringVelocity: self.velocity,
                               options: self.options,
                               animations: {
                                   let x = by[0] + self.view.center.x
                                   let y = by[1] + self.view.center.y
                                   self.view.center = CGPoint(x: x, y: y)
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
                               animations: {
                                   let x = to[0]
                                   let y = to[1]
                                   let t = CATransform3DMakeTranslation(x, y, 0)
                                   self.view.layer.transform = t
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
                               animations: {
                                   let x = by[0]
                                   let y = by[1]
                                   let t = CATransform3DTranslate(self.view.layer.transform, x, y, 0)
                                   self.view.layer.transform = t
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
                               animations: {
                                   let t = CATransform3DMakeScale(to, to, 1)
                                   self.view.layer.transform = t
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
                               animations: {
                                   let t = CATransform3DScale(self.view.layer.transform, by, by, 1)
                                   self.view.layer.transform = t
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
                               animations: {
                                   let radians = CGFloat(to * Double.pi / 180)
                                   let t = CATransform3DMakeRotation(radians, 0, 0, 1)
                                   self.view.layer.transform = t
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
                               animations: {
                                   let radians = CGFloat(by * Double.pi / 180)
                                   let t = CATransform3DRotate(self.view.layer.transform, radians, 0, 0, 1)
                                   self.view.layer.transform = t
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
                               animations: {
                                   self.view.layer.transform = CATransform3DIdentity
                                   if self.moved {
                                       self.move(to: self.origin)
                                       self.moved = false
                                   }
                               }, completion: { (finished: Bool) in
                                   then?()
                               })
            }
        }
        return self
    }

}
