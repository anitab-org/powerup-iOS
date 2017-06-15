/** Storing the information of each guessing boxes of Minesweeping mini game */

import SpriteKit

class GuessingBox: SKSpriteNode {
    
    // MARK: Constants
    let backsideTexture = SKTexture(imageNamed: "minesweeper_yellowstar_box")
    let failureTexture = SKTexture(imageNamed: "minesweeper_redstar_box")
    let greenStarTexture = SKTexture(imageNamed: "minesweeper_greenstar_box")
    
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
}
