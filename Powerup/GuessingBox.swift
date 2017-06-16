/** Storing the information of each guessing boxes of Minesweeping mini game */

import SpriteKit

class GuessingBox: SKSpriteNode {
    
    // MARK: Constants
    let backsideTexture = SKTexture(imageNamed: "minesweeper_yellowstar_box")
    let failureTexture = SKTexture(imageNamed: "minesweeper_redstar_box")
    let successTexture = SKTexture(imageNamed: "minesweeper_greenstar_box")
    
    // Animation constants.
    let flipDuration = 0.6
    
    // MARK: Properties
    var xOfGrid: Int
    var yOfGrid: Int
    
    var isCorrect: Bool
    
    // MARK: Constructors
    init(xOfGrid: Int, yOfGrid: Int, isCorrect: Bool, size: CGSize) {
        self.xOfGrid = xOfGrid
        self.yOfGrid = yOfGrid
        self.isCorrect = isCorrect
        
        super.init(texture: backsideTexture, color: SKColor.clear, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    /** Flip the box with flipping animation */
    func flip(toFront: Bool, scaleX: CGFloat, completion: @escaping () -> ()) {
        // Animated
        let firstHalfFlip = SKAction.scaleX(to: 0.0, duration: flipDuration / 2.0)
        let secondHalfFlip = SKAction.scaleX(to: scaleX, duration: flipDuration / 2.0)
        
        if toFront {
            self.run(firstHalfFlip) {
                self.texture = self.isCorrect ? self.successTexture : self.failureTexture
                self.run(secondHalfFlip, completion: completion)
            }
        } else {
            self.run(firstHalfFlip) {
                self.texture = self.backsideTexture
                self.run(secondHalfFlip, completion: completion)
            }
        }
    }
    
    /** Change side without animation */
    func changedSide(toFront: Bool) {
        if toFront {
            self.texture = self.isCorrect ? self.successTexture : self.failureTexture
        } else {
            self.texture = self.backsideTexture
        }
    }
    
}
