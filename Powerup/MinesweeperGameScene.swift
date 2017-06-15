import SpriteKit

class MinesweeperGameScene: SKScene {
    
    // TODO: Move the contraception data to database.
    let possiblityPercentageEachRound = [40.5, 85.0, 90.4, 80.4, 11.5]
    
    // MARK: Game Constants
    let gridSizeCount = 5
    let totalRoundsPerGameSession = 5
    
    // Animation constants.
    let boxEnlargingScale = CGFloat(1.15)
    let boxEnlargingDuration = 0.25
    let boxEnlargingKey = "enlarge"
    let boxShrinkingKey = "shrink"
    
    // Layer Index, aka. zPosition.
    let gridLayer = CGFloat(0.1)
    
    // These are relative to the size of the view, so they can be applied to different screen sizes.
    let gridOffsetXRelativeToWidth = 0.31
    let gridOffsetYRelativeToHeight = 0.0822
    let gridSpacingRelativeToWidth = 0.0125
    let boxSizeRelativeToWidth = 0.084
    
    // These are the actual sizing and positioning, will be calculated in init()
    let boxSize: Double
    let gridOffsetX: Double
    let gridOffsetY: Double
    let gridSpacing: Double
    
    let backgroundImage = SKSpriteNode(imageNamed: "minesweeper_background")
    
    // Layer index, aka. zPosition.
    let backgroundLayer = CGFloat(-0.1)
    
    // MARK: Properties
    // Holding each boxes
    var gameGrid: [[GuessingBox]] = []
    var roundCount = 0
    
    var currBox: GuessingBox? = nil
    
    // MARK: Constructor
    override init(size: CGSize) {
        
        // Calcuate positioning and sizing according to the size of the view.
        boxSize = Double(size.width) * boxSizeRelativeToWidth
        gridOffsetX = Double(size.width) * gridOffsetXRelativeToWidth + boxSize / 2.0
        gridOffsetY = Double(size.height) * gridOffsetYRelativeToHeight + boxSize / 2.0
        gridSpacing = Double(size.width) * gridSpacingRelativeToWidth
        
        super.init(size: size)
        
        // Initialize grid.
        for x in 0..<gridSizeCount {
            gameGrid.append([GuessingBox]())
            for y in 0..<gridSizeCount {
                let newBox = GuessingBox(xOfGrid: x, yOfGrid: y, isCorrect: false, size: CGSize(width: boxSize, height: boxSize))
                
                // Positioning and sizing.
                let xPos = gridOffsetX + (boxSize + gridSpacing) * Double(x)
                let yPos = gridOffsetY + (boxSize + gridSpacing) * Double(y)
                newBox.position = CGPoint(x: xPos, y: yPos)
                newBox.zPosition = gridLayer
                
                gameGrid[x].append(newBox)
            }
        }
        
        // Start the first round.
        newRound(with: possiblityPercentageEachRound[roundCount])
    }
    
    // MARK: Functions
    
    /**
      Reset the grid for a new round.
      - Parameter: The possibility of the contrceptive method in percentage.
    */
    func newRound(with possibility: Double) {
        roundCount += 1
        
        // Successful boxes, grounded to an interger.
        let totalBoxCount = gridSizeCount * gridSizeCount
        let successfulBoxCount = Int(Double(totalBoxCount) * possibility / 100.0)
        let failureBoxCount = totalBoxCount - successfulBoxCount
        
        // An array of true/false values according to the success rate.
        var correctBoxes = [Bool](repeating: true, count: successfulBoxCount)
        correctBoxes.append(contentsOf: [Bool](repeating: false, count: failureBoxCount))
        
        // Shuffle the array randomly.
        correctBoxes.shuffle()
        
        // Configure each box.
        for x in 0..<gridSizeCount {
            for y in 0..<gridSizeCount {
                gameGrid[x][y].isCorrect = correctBoxes.popLast()!
            }
        }
    }
    
    // TODO: Flip cards.
    // TODO: Show banner.
    // TODO: Show description.
    
    // For initializing the nodes of the game.
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        
        // Add background image.
        backgroundImage.size = size
        backgroundImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundImage.zPosition = backgroundLayer
        addChild(backgroundImage)
        
        // Add boxes.
        for gridX in gameGrid {
            for box in gridX {
                addChild(box)
            }
        }
    }
    
    // MARK: Touch inputs.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Only the first touch is effective.
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        if let guessingBox = atPoint(location) as? GuessingBox {
            currBox = guessingBox
            
            // Perform animation.
            guessingBox.removeAction(forKey: boxShrinkingKey)
            guessingBox.run(SKAction.scale(to: boxEnlargingScale, duration: boxEnlargingDuration), withKey: boxEnlargingKey)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Only the first touch is effective.
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        if let guessingBox = atPoint(location) as? GuessingBox, guessingBox == currBox {
        } else if let box = currBox {
            
            // Animate (shrink) back the card.
            box.removeAction(forKey: boxEnlargingKey)
            box.run(SKAction.scale(to: 1.0, duration: boxEnlargingDuration), withKey: boxEnlargingKey)
            
            currBox = nil
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented.")
    }
}
