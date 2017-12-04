/** Storing the information of each guessing boxes of Minesweeping mini game */

import SpriteKit

class GuessingBox: SKSpriteNode {
    
    // MARK: Constants
    @objc let backsideTexture = SKTexture(imageNamed: "minesweeper_yellowstar_box")
    @objc let failureTexture = SKTexture(imageNamed: "minesweeper_redstar_box")
    @objc let successTexture = SKTexture(imageNamed: "minesweeper_greenstar_box")
    
    // Animation constants.
    @objc let flipDuration = 0.6
    
    // MARK: Properties
    @objc var xOfGrid: Int
    @objc var yOfGrid: Int
    
    @objc var onFrontSide: Bool = false
    @objc var isCorrect: Bool
    
    // MARK: Constructors
    @objc init(xOfGrid: Int, yOfGrid: Int, isCorrect: Bool, size: CGSize) {
        self.xOfGrid = xOfGrid
        self.yOfGrid = yOfGrid
        self.isCorrect = isCorrect
        
        super.init(texture: backsideTexture, color: SKColor.clear, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    /**
      Flip the box with flipping animation
      - Parameter: The ending scaleX of the flip animation.
     */
    @objc func flip(scaleX: CGFloat, completion: @escaping () -> ()) {
        // Animated
        let firstHalfFlip = SKAction.scaleX(to: 0.0, duration: flipDuration / 2.0)
        let secondHalfFlip = SKAction.scaleX(to: scaleX, duration: flipDuration / 2.0)
        
        onFrontSide = !onFrontSide
        if onFrontSide {
            // Flip to front.
            self.run(firstHalfFlip) {
                self.texture = self.isCorrect ? self.successTexture : self.failureTexture
                self.run(secondHalfFlip, completion: completion)
            }
        } else {
            // Flip to back.
            self.run(firstHalfFlip) {
                self.texture = self.backsideTexture
                self.run(secondHalfFlip, completion: completion)
            }
        }
    }
    
    /** Change side without animation, could be used to reset the box. */
    @objc func changeSide() {
        
        onFrontSide = !onFrontSide
        if onFrontSide {
            self.texture = self.isCorrect ? self.successTexture : self.failureTexture
        } else {
            self.texture = self.backsideTexture
        }
    }
    
}
