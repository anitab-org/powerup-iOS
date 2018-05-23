//
//  Animate.swift
//  Powerup
//
//  Created by KD on 5/22/18.
//  Copyright © 2018 Systers. All rights reserved.
//

import UIKit

struct Animate {

    /**
     Scale animation.
     
     - parameters:
     - view: UIView
     - size: CGFloat - Applied to both x and y domains.
     - duration: Double
     */
    func scale(view: UIView, size: CGFloat, duration: Double) {
        scale(view: view, size: size, duration: duration, damping: 1, velocity: 1)
    }

    /**
     Scale animation with spring physics.
     
     - parameters:
        - view: UIView
        - size: CGFloat - Applied to both x and y domains.
        - duration: Double
        - damping: CGFloat
        - velocity: CGFloat
     */
    func scale(view: UIView, size: CGFloat, duration: Double, damping: CGFloat, velocity: CGFloat) {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: duration,
                               delay: 0,
                               usingSpringWithDamping: damping,
                               initialSpringVelocity: velocity,
                               options: .curveEaseOut,
                               animations: {
                                   view.layer.transform = CATransform3DMakeScale(size, size, 1)
                               })
            }
        }
    }

    /**
     Move animation.
     
     - parameters:
        - view: UIView
        - x: CGFloat
        - y: CGFloat
        - duration: Double
     */
    func translate(view: UIView, x: CGFloat, y: CGFloat, duration: Double) {
        translate(view: view, x: x, y: y, duration: duration, damping: 1, velocity: 1)
    }

    /**
     Move animation with spring physics.
     
     - parameters:
        - view: UIView
        - x: CGFloat
        - y: CGFloat
        - duration: Double
        - damping: CGFloat
        - velocity: CGFloat
     */
    func translate(view: UIView, x: CGFloat, y: CGFloat, duration: Double, damping: CGFloat, velocity: CGFloat) {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: duration,
                               delay: 0,
                               usingSpringWithDamping: damping,
                               initialSpringVelocity: velocity,
                               options: .curveEaseOut,
                               animations: {
                                   view.layer.transform = CATransform3DMakeTranslation(x, y, 0)
                               })
            }
        }
    }

    /**
     Rotate to target degrees, then reset to original position. Duration is the complete animation, not just one rotation.
     
     - parameters:
        - view: UIView
        - degrees: Double - Amount to rotate. Positive or negative determines direction.
        - duration: Double
     */
    func tilt(view: UIView, degrees: Double, duration: Double) {
        rotate(view: view, degrees: degrees, duration: duration / 2)
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration / 2) {
                self.identity(view, duration / 2)
            }
        }
    }

    /**
     Rotation shake animation.
     
     - parameters:
        - view: UIView
        - degrees: Double - Amount to rotate. Positive or negative determines direction.
        - duration: Double
     */
    func rotate(view: UIView, degrees: Double, duration: Double) {
        rotate(view: view, degrees: degrees, duration: duration, damping: 1, velocity: 1)
    }

    /**
     Rotation animation with spring physics.
     
     - parameters:
        - view: UIView
        - degrees: Double - Amount to rotate. Positive or negative determines direction.
        - duration: Double
        - damping: CGFloat
        - velocity: CGFloat
     */
    func rotate(view: UIView, degrees: Double, duration: Double, damping: CGFloat, velocity: CGFloat) {
        let radians = CGFloat(degrees * Double.pi / 180)
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: duration,
                               delay: 0,
                               usingSpringWithDamping: damping,
                               initialSpringVelocity: velocity,
                               options: .curveEaseOut,
                               animations: {
                                   view.layer.transform = CATransform3DMakeRotation(radians, 0, 0, 1)
                               })
            }
        }
    }

    /**
     Horizontal shake animation.
     
     - parameters:
        - view: UIView
        - keys: Array<Double>? - An array describing points to move to along the x-axis in reference to the x origin. A `nil` value will use a predefined shake animation.
     */
    // DOES NOT WORK CORRECTLY ON IMAGES NOT AT ORIGIN 0 
    func shake(_ view: UIView, _ keys: Array<Double>?) {
        // store origin as the reference
        let x = view.frame.origin.x
        // duration of the entire animation event
        let dur: Double = 0.4
        // target positions in reference to the origin
        // so the default array would read as:
        // move to origin+10, then origin-10, then origin+7, etc.
        let defaultKeys: Array<Double> = [10, -10, 7, -7, 4, -4, 1, -1]
        // use a supplied array, else use the default array
        let k: Array<Double> = (keys != nil) ? keys! : defaultKeys
        // duration of a single animation event
        let oneDur: Double = dur / Double(k.count)
        // loop through keys and animate to each in turn
        for i in 0..<k.count {
            // delay each animation by an appropriate amount so they happen consecutively
            let thisDur: Double = oneDur * Double(i + 1)

            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.asyncAfter(deadline: .now() + thisDur) {
                    self.translate(view: view, x: x + CGFloat(k[i]), y: 0, duration: oneDur, damping: 0.5, velocity: 10)
                }
            }
        }
        // reset to original position after shake is finished
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + dur) {
                self.identity(view, 0)
            }
        }
    }

    /**
     Reset view layer transform back to original position and state.
     */
    func identity(_ view: UIView, _ duration: Double) {
        identity(view: view, duration: duration, damping: 1, velocity: 1)
    }

    /**
     Reset view layer transform back to original position and state with spring physics.
     */
    func identity(view: UIView, duration: Double, damping: CGFloat, velocity: CGFloat) {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: duration,
                               delay: 0,
                               usingSpringWithDamping: 1,
                               initialSpringVelocity: 1,
                               options: .curveEaseOut,
                               animations: {
                                   view.layer.transform = CATransform3DIdentity
                               })
            }
        }
    }
}
