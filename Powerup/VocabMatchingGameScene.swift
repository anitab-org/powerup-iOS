import SpriteKit

class VocabMatchingGameScene: SKScene {
    // TODO: Store the information of each round in the database.
    // Matching ID, Texture name.
    let tilesEachRound = [
        (0, "vocabmatching_tile_lingerie"),
        (1, "vocabmatching_tile_pimple"),
        (2, "vocabmatching_tile_pad")
    ]
    
    // Matching ID, description Text.
    let clipboardEachRound = [
        (0, "Lingerie"),
        (1, "Pimple"),
        (2, "Sanitary Pad")
    ]
    
    // MARK: Constants
    let timeForTileToReachClipboard = 10.0
    
    // Sizing and position of the nodes (They are relative to the width and height of the game scene.)
    // Score Box
    let scoreBoxSpriteWidth = 0.19
    let scoreBoxSpriteHeight = 0.295
    let scoreBoxSpritePosY = 0.81
    
    // The positionY of each lane. (That is, the posY of tiles and clipboards.)
    let lanePositionsY = [0.173, 0.495, 0.828]
    
    // Tile
    let tileSpriteSizeRelativeToWidth = 0.16
    let tileSpriteSpawnPosX = 0.0
    let tileTouchesClipboardPosX = 0.7
    
    // Clipboard
    let clipboardSpriteWidth = 0.24
    let clipboardSpriteHeight = 0.29
    let clipboardSpritePosX = 0.855
    
    // Sprite Nodes
    let scoreBoxSprite = SKSpriteNode(imageNamed: "vocabmatching_scorebox")
    let backgroundSprite = SKSpriteNode(imageNamed: "vocabmatching_background")
    
    // Textures
    let tileTexture = SKTexture(imageNamed: "vocabmatching_tile")
    let clipboardTexture = SKTexture(imageNamed: "vocabmatching_clipboard")
    
    // Layers (zPosition)
    let backgroundLayer = CGFloat(-0.1)
    let clipboardLayer = CGFloat(0.2)
    let clipboardDraggingLayer = CGFloat(0.3)
    let tileLayer = CGFloat(0.4)
    let uiLayer = CGFloat(0.5)
    let uiTextLayer = CGFloat(0.6)
    
    // Fonts
    let fontName = "Montserrat-Bold"
    let fontColor = UIColor(colorLiteralRed: 21.0 / 255.0, green: 124.0 / 255.0, blue: 129.0 / 255.0, alpha: 1.0)
    
    // Font size
    let clipboardFontSize = CGFloat(14)
    
    // If there are too many (longTextDef) characters in the string of the pad, shrink it.
    let clipboardLongTextFontSize = CGFloat(10)
    let clipboardLongTextDef = 12
    
    // Animations
    let swappingAnimationDuration = 0.2
    
    // MARK: Properties
    // The clipboards which could be swapped.
    var clipboards: [VocabMatchingClipboard]
    
    // Tiles prepared to be spawned.
    var tiles: [VocabMatchingTile]
    
    var currRound: Int = -1
    
    // Keep a reference to the mini game view controller for end game transition.
    var viewController: MiniGameViewController!
    
    // The clipboard currently being dragged.
    var clipboardDragged: VocabMatchingClipboard? = nil
    
    // Cannot perform another swap if some clipboards are currently swapping.
    var isSwapping = false
    
    // MARK: Constructors
    override init(size: CGSize) {
        let gameWidth = Double(size.width)
        let gameHeight = Double(size.height)
        
        // Sizing and positioning the background image.
        backgroundSprite.position = CGPoint(x: gameWidth / 2.0, y: gameHeight / 2.0)
        backgroundSprite.size = size
        backgroundSprite.zPosition = backgroundLayer
        
        // Sizing and positioning the score box.
        // Score box's pivot is at the middle left.
        scoreBoxSprite.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        scoreBoxSprite.position = CGPoint(x: 0.0, y: gameHeight * scoreBoxSpritePosY)
        scoreBoxSprite.size = CGSize(width: gameWidth * scoreBoxSpriteWidth, height: gameHeight * scoreBoxSpriteHeight)
        scoreBoxSprite.zPosition = uiLayer
        
        // Initialize the clipboards.
        clipboards = [VocabMatchingClipboard]()
        for index in 0..<lanePositionsY.count {
            let currClipboard = VocabMatchingClipboard(texture: clipboardTexture, size: CGSize(width: gameWidth * clipboardSpriteWidth, height: gameHeight * clipboardSpriteHeight), matchingID: clipboardEachRound[index].0, description: clipboardEachRound[index].1)
            
            // Configure font.
            currClipboard.descriptionLabel.fontName = fontName
            currClipboard.descriptionLabel.fontColor = fontColor
            if currClipboard.descriptionLabel.text!.characters.count >= clipboardLongTextDef {
                currClipboard.descriptionLabel.fontSize = clipboardLongTextFontSize
            } else {
                currClipboard.descriptionLabel.fontSize = clipboardFontSize
            }
            
            // Positioning
            currClipboard.position = CGPoint(x: gameWidth * clipboardSpritePosX, y: gameHeight * lanePositionsY[index])
            currClipboard.zPosition = clipboardLayer
            
            clipboards.append(currClipboard)
        }
        
        // Initialize tile array.
        tiles = [VocabMatchingTile]()
        for (matchingID, textureName) in tilesEachRound {
            let currTile = VocabMatchingTile(matchingID: matchingID, textureName: textureName, size: CGSize(width: gameWidth * tileSpriteSizeRelativeToWidth, height: gameWidth * tileSpriteSizeRelativeToWidth))
            currTile.zPosition = tileLayer
            tiles.append(currTile)
        }
        
        // Shuffle the array so the elements are in random order.
        tiles.shuffle()
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented.")
    }
    
    // MARK: Functions
    
    // For initializing the nodes of the game.
    override func didMove(to view: SKView) {
        // Add background image.
        addChild(backgroundSprite)
        
        // Add clipboards.
        for clipboard in clipboards {
            addChild(clipboard)
        }
        
        // Add scorebox.
        addChild(scoreBoxSprite)
        
        // Start the game (spawn the first tile).
        spawnNextTile()
    }
    
    // Spawn the next tile and moving it towards clipboards.
    func spawnNextTile() {
        currRound += 1
        
        let nextTile = tiles[currRound]
        
        // Spawn in a random lane.
        nextTile.laneNumber = Int(arc4random_uniform(UInt32(lanePositionsY.count)))
        
        nextTile.position = CGPoint(x: Double(size.width) * tileSpriteSpawnPosX, y: Double(size.height) * lanePositionsY[nextTile.laneNumber])
        addChild(nextTile)
        
        // Move the tile to the clipboards.
        let destination = CGPoint(x: size.width * CGFloat(tileTouchesClipboardPosX), y: nextTile.position.y)
        let action = SKAction.move(to: destination, duration: timeForTileToReachClipboard)
        nextTile.run(action)
    }
    
    // After dragging and dropping a clipboard, check which lane is closer, and snap it to the lane and swap the positions. If it isn't dragged to the other lanes, no swapping will be performed, just snap it back to its original lane.
    func snapClipboardToClosestLane(droppedClipboard: VocabMatchingClipboard, dropLocationPosY: Double) {
        // Check which clipboard is being dragged.
        var clipboardIndex = 0
        while clipboards[clipboardIndex] != droppedClipboard {
            clipboardIndex += 1
        }
        
        // Find the closest lane to snap to.
        var closestLaneIndex = 0
        var closestLaneDistance = Double.infinity
        for (index, positionY) in lanePositionsY.enumerated() {
            let distanceToCurrentLane = abs(positionY * Double(size.height) - dropLocationPosY)
            if distanceToCurrentLane < closestLaneDistance {
                closestLaneIndex = index
                closestLaneDistance = distanceToCurrentLane
            }
        }
        
        let snappingDestination = CGPoint(x: Double(size.width) * clipboardSpritePosX, y: Double(size.height) * lanePositionsY[closestLaneIndex])
        
        // Snap to the original lane.
        if clipboardIndex == closestLaneIndex {
            isSwapping = true
            
            // Perform snapping animation.
            let snappingAnimation = SKAction.move(to: snappingDestination, duration: swappingAnimationDuration)
            droppedClipboard.run(snappingAnimation) {
                self.isSwapping = false
            }
        } else {
            // Swap with the clipboard on the other lane.
            isSwapping = true
            
            // The original location of the dropped clipboard.
            let originalLocation = CGPoint(x: Double(size.width) * clipboardSpritePosX, y: Double(size.height) * lanePositionsY[clipboardIndex])
            
            // Perform swapping animation.
            let droppedClipboardSwapAnimation = SKAction.move(to: snappingDestination, duration: swappingAnimationDuration)
            let destinationClipboardSwapAnimation = SKAction.move(to: originalLocation, duration: swappingAnimationDuration)
            
            // Set the dragged clipboard to the front.
            droppedClipboard.zPosition = clipboardDraggingLayer
            
            droppedClipboard.run(droppedClipboardSwapAnimation)
            clipboards[closestLaneIndex].run(destinationClipboardSwapAnimation) {
                // Swap the indices.
                (self.clipboards[closestLaneIndex], self.clipboards[clipboardIndex]) = (self.clipboards[clipboardIndex], self.clipboards[closestLaneIndex])
                
                self.isSwapping = false
                
                // Set the z position back.
                droppedClipboard.zPosition = self.clipboardLayer
            }
        }
    }
    
    // MARK: Touch Inputs
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // If the previous swapping animation isn't finished, return.
        if isSwapping { return }
        
        // Only the first touch is effective.
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        
        // Check if the touch lands on a clipboard, if so, start dragging it.
        if let clipboard = atPoint(location) as? VocabMatchingClipboard {
            // Update clipboard's zPosition so that it appears at the front.
            clipboard.zPosition = clipboardDraggingLayer
            
            clipboardDragged = clipboard
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // If the previous swapping animation isn't finished, return.
        if isSwapping { return }
        
        // Only the first touch is effective.
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        
        // If there is a clipboard currently being dragged, update its position.
        if clipboardDragged != nil {
            clipboardDragged!.position = CGPoint(x: CGFloat(clipboardSpritePosX) * size.width, y: location.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // If the previous swapping animation isn't finished, return.
        if isSwapping { return }
        
        // Only the first touch is effective.
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        
        // If there is a clipboard currently dragged, drop it.
        if let clipboard = clipboardDragged {
            // Reset cardboard's zPosition.
            clipboard.zPosition = clipboardLayer
            
            // Make the cardboard appear in the front by readding it to the scene.
            clipboard.removeFromParent()
            addChild(clipboard)
            
            // Snap the clipboard.
            snapClipboardToClosestLane(droppedClipboard: clipboard, dropLocationPosY: Double(location.y))
            
            // Stop dragging.
            clipboardDragged = nil
        }
    }
}
