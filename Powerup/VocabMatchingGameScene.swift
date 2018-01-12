import SpriteKit

class VocabMatchingGameScene: SKScene {
    // TODO: Store the information of each round in the database.
    // Matching ID, Texture name.
    let tileTypes = [
        (0, "vocabmatching_tile_lingerie", "Lingerie"),
        (1, "vocabmatching_tile_pimple", "Pimple"),
        (2, "vocabmatching_tile_pad", "Sanitary Pad"),
        (3, "vocabmatching_tile_cramping", "Cramping"),
        (4, "vocabmatching_tile_skinny", "Skinny"),
        (5, "vocabmatching_tile_deodorant", "Deodorant"),
        (6, "vocabmatching_tile_fat", "Fat"),
        (7, "vocabmatching_tile_tampon", "Tampon"),
        (8, "vocabmatching_tile_depression", "Depression")
    ]
    
    // MARK: Constants
    let timeForTileToReachClipboard = 6.0
    let delayTimeToNextRound = 0.25
    let totalRounds = 5
    let tilesPerRound = 3
    let timeBetweenTileSpawns = 2.0
    
    // Tutorial Scene images.
    let tutorialSceneImages = ["vocabmatching_tutorial_1", "vocabmatching_tutorial_2"]
    
    // Sizing and position of the nodes (They are relative to the width and height of the game scene.)
    // Score Box
    let scoreBoxSpriteWidth = 0.09
    let scoreBoxSpriteHeight = 0.15
    let scoreBoxSpritePosY = 0.9
    
    // The following two is relative to the score box.
    let scoreLabelPosX = 0.4
    let scoreLabelPosY = -0.1
    
    // Tile
    let tileSpriteSizeRelativeToWidth = 0.14
    let tileSpriteSpawnPosX = 0.0
    let tileTouchesClipboardPosX = 0.7
    
    // Clipboard
    let clipboardSpriteWidth = 0.24
    let clipboardSpriteHeight = 0.29
    let clipboardSpritePosX = 0.855
    
    // Continue button
    let continueButtonBottomMargin = 0.08
    let continueButtonHeightRelativeToSceneHeight = 0.15
    let continueButtonAspectRatio = 2.783
    
    // End scene labels
    let endSceneTitleLabelPosX = 0.0
    let endSceneTitleLabelPosY = 0.1
    let endSceneScoreLabelPosX = 0.0
    let endSceneScoreLabelPosY = -0.1
    
    // Sprite Nodes
    let scoreBoxSprite = SKSpriteNode(imageNamed: "vocabmatching_scorebox")
    let backgroundSprite = SKSpriteNode(imageNamed: "vocabmatching_background")
    let endSceneSprite = SKSpriteNode()
    let continueButton = SKSpriteNode(imageNamed: "continue_button")
    
    // Label Nodes & Label Wrapper Node
    let scoreLabelWrapper = SKNode()
    let endSceneTitleLabelWrapper = SKNode()
    let endSceneScoreLabelWrapper = SKNode()
    let scoreLabel = SKLabelNode()
    let endSceneTitleLabel = SKLabelNode()
    let endSceneScoreLabel = SKLabelNode()
    
    // Textures
    let tileTexture = SKTexture(imageNamed: "vocabmatching_tile")
    let clipboardTexture = SKTexture(imageNamed: "vocabmatching_clipboard")
    let clipboardCorrectTexture = SKTexture(imageNamed: "vocabmatching_clipboard_green")
    let clipboardWrongTexture = SKTexture(imageNamed: "vocabmatching_clipboard_red")
    
    // Layers (zPosition)
    let backgroundLayer = CGFloat(-0.1)
    let clipboardLayer = CGFloat(0.2)
    let clipboardDraggingLayer = CGFloat(0.3)
    let tileLayer = CGFloat(0.4)
    let uiLayer = CGFloat(0.5)
    let uiTextLayer = CGFloat(0.6)
    let endSceneLayer = CGFloat(1.5)
    let tutorialSceneLayer = CGFloat(5)
    
    // Fonts
    let fontName = "Montserrat-Bold"
    let fontColor = UIColor(colorLiteralRed: 21.0 / 255.0, green: 124.0 / 255.0, blue: 129.0 / 255.0, alpha: 1.0)
    
    // Font size
    let clipboardFontSize = CGFloat(14)
    let scoreFontSize = CGFloat(16)
    let endSceneTitleFontSize = CGFloat(20)
    
    // If there are too many (longTextDef) characters in the string of the pad, shrink it.
    let clipboardLongTextFontSize = CGFloat(10)
    let clipboardLongTextDef = 12
    
    // Animations
    let swappingAnimationDuration = 0.2
    let endSceneFadeInAnimationDuration = 0.5
    let clipboardStarBlinkAnimationDuration = 0.3
    
    // Strings
    let endSceneTitleLabelText = "Game Over"
    let scoreLabelPrefix = "Score: "
    
    // MARK: Properties
    var tutorialScene: SKTutorialScene!
    
    // The positionY of each lane. (That is, the posY of tiles and clipboards.)
    var lanePositionsY = [0.173, 0.495, 0.828]
    
    // The clipboards which could be swapped.
    var clipboards: [VocabMatchingClipboard]
    
    var currRound: Int = -1
    
    // Keep a reference to the mini game view controller for end game transition.
    var viewController: MiniGameViewController!
    
    // The clipboard currently being dragged.
    var clipboardDragged: VocabMatchingClipboard? = nil
    
    // Cannot perform another swap if some clipboards are currently swapping.
    var isSwapping = false
    
    var isContinueButtonInteractable = false
    
    var score: Int = 0
    
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
            let currClipboard = VocabMatchingClipboard(texture: clipboardTexture, size: CGSize(width: gameWidth * clipboardSpriteWidth, height: gameHeight * clipboardSpriteHeight), matchingID: -1, description: "")
            
            // Configure font.
            currClipboard.descriptionLabel.fontName = fontName
            currClipboard.descriptionLabel.fontColor = fontColor
            
            // Positioning
            currClipboard.position = CGPoint(x: gameWidth * clipboardSpritePosX, y: gameHeight * lanePositionsY[index])
            currClipboard.zPosition = clipboardLayer
            
            clipboards.append(currClipboard)
        }
        
        // Score Label
        scoreBoxSprite.addChild(scoreLabelWrapper)
        scoreLabelWrapper.position = CGPoint(x: Double(scoreBoxSprite.size.width) * scoreLabelPosX, y: Double(scoreBoxSprite.size.height) * scoreLabelPosY)
        scoreLabelWrapper.addChild(scoreLabel)
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.zPosition = uiTextLayer
        scoreLabel.fontName = fontName
        scoreLabel.fontColor = fontColor
        scoreLabel.fontSize = scoreFontSize
        scoreLabel.text = "0"
        
        // Sizing and positioning ending scene.
        endSceneSprite.size = CGSize(width: size.width, height: size.height)
        endSceneSprite.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        endSceneSprite.color = UIColor.white
        endSceneSprite.zPosition = endSceneLayer
        
        // End scene labels.
        endSceneSprite.addChild(endSceneTitleLabelWrapper)
        endSceneTitleLabelWrapper.position = CGPoint(x: gameWidth * endSceneTitleLabelPosX, y: gameHeight * endSceneTitleLabelPosY)
        endSceneTitleLabelWrapper.zPosition = uiTextLayer
        endSceneTitleLabelWrapper.addChild(endSceneTitleLabel)
        
        endSceneTitleLabel.fontName = fontName
        endSceneTitleLabel.fontColor = fontColor
        endSceneTitleLabel.fontSize = endSceneTitleFontSize
        endSceneTitleLabel.text = endSceneTitleLabelText
        endSceneTitleLabel.horizontalAlignmentMode = .center
        endSceneTitleLabel.verticalAlignmentMode = .center
        
        endSceneSprite.addChild(endSceneScoreLabelWrapper)
        endSceneScoreLabelWrapper.position = CGPoint(x: gameWidth * endSceneScoreLabelPosX, y: gameHeight * endSceneScoreLabelPosY)
        endSceneScoreLabelWrapper.zPosition = uiTextLayer
        endSceneScoreLabelWrapper.addChild(endSceneScoreLabel)
        
        endSceneScoreLabel.fontName = fontName
        endSceneScoreLabel.fontColor = fontColor
        endSceneScoreLabel.fontSize = scoreFontSize
        endSceneScoreLabel.text = scoreLabelPrefix
        endSceneScoreLabel.horizontalAlignmentMode = .center
        endSceneScoreLabel.verticalAlignmentMode = .center
        
        // End scene continue button.
        endSceneSprite.addChild(continueButton)
        continueButton.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        continueButton.size = CGSize(width: continueButtonAspectRatio * continueButtonHeightRelativeToSceneHeight * gameHeight, height: gameHeight * continueButtonHeightRelativeToSceneHeight)
        continueButton.position = CGPoint(x: gameWidth / 2.0, y: gameHeight * (-0.5 + continueButtonBottomMargin))
        continueButton.zPosition = uiLayer
        
        // Hide end scene.
        endSceneSprite.isHidden = true
        
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
        
        // Add end scene.
        addChild(endSceneSprite)
        
        if !UserDefaults.standard.bool(forKey: "VocabTutsViewed") {
            // Show tutorial scene. After that, start the game.
            tutorialScene = SKTutorialScene(namedImages: tutorialSceneImages, size: size) {
                self.nextRound()
            }
            tutorialScene.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
            tutorialScene.zPosition = tutorialSceneLayer
            addChild(tutorialScene)
            UserDefaults.standard.set(true, forKey: "VocabTutsViewed")
        } else {
            // It is not the user's 1st time playing the game, so skip tutorials
            self.nextRound()
        }
    }
    
    // Spawn tiles for the next round. Completion closure is for unit tests.
    func nextRound(completion: (()->())? = nil) {
        currRound += 1
        
        let tilesToSpawn = getRandomizedTilesForRound()
        
        configureClipboardsForNewRound(tiles: tilesToSpawn)
        
        // Configure the spawning actions.
        var actionSequence = [SKAction]()
        for tile in tilesToSpawn {
            // Tile spawn.
            actionSequence.append(SKAction.run({self.spawnNextTile(tile: tile)}))
            
            // Delay time.
            actionSequence.append(SKAction.wait(forDuration: timeBetweenTileSpawns))
        }
        
        // Delay time to next round.
        actionSequence.append(SKAction.wait(forDuration: timeForTileToReachClipboard - timeBetweenTileSpawns + delayTimeToNextRound))
        
        // Run action.
        run(SKAction.sequence(actionSequence)) {
            
            // If it is not the last round, spawn next tile.
            if self.currRound + 1 < self.totalRounds {
                self.nextRound()
            } else {
                // Fade in end scene.
                self.endSceneSprite.alpha = 0.0
                self.endSceneSprite.isHidden = false
                self.endSceneScoreLabel.text = self.scoreLabelPrefix + String(self.score)
                self.endSceneSprite.run(SKAction.fadeIn(withDuration: self.endSceneFadeInAnimationDuration)) {
                    self.isContinueButtonInteractable = true
                }
            }
            
            if completion != nil { completion!() }
        }
    }
    
    // Get an array of randomized tiles for the new round.
    func getRandomizedTilesForRound() -> [VocabMatchingTile] {
        var tilesToSpawn = [VocabMatchingTile]()
        
        // Randomize the spawning tiles for this round (tile icon & lane number).
        var randomizedTiles = tileTypes
        randomizedTiles.shuffle()
        
        var laneNumbers = getRandomLaneNumbers()
        
        // Configure tile.
        for index in 0..<tilesPerRound {
            let tileType = randomizedTiles[index]
            
            let currTile = VocabMatchingTile(matchingID: tileType.0, textureName: tileType.1, descriptionText: tileType.2, size: CGSize(width: Double(size.width) * tileSpriteSizeRelativeToWidth, height: Double(size.width) * tileSpriteSizeRelativeToWidth))
            currTile.laneNumber = laneNumbers[index]
            
            // Positioning
            currTile.position = CGPoint(x: Double(size.width) * tileSpriteSpawnPosX, y: Double(size.height) * lanePositionsY[laneNumbers[index]])
            currTile.zPosition = tileLayer
            
            tilesToSpawn.append(currTile)
        }
        
        return tilesToSpawn
    }
    
    // Configure the clipboards for a new round.
    func configureClipboardsForNewRound(tiles: [VocabMatchingTile]) {
        var laneNumbers = getRandomLaneNumbers()
        
        // Configure the clipboards so that the tiles would have a match.
        for (index, tile) in tiles.enumerated() {
            let randomClipboard = clipboards[laneNumbers[index]]
            
            randomClipboard.descriptionLabel.text = tile.descriptionText
            randomClipboard.matchingID = tile.matchingID
            
            // Shrink text size if the string is too long.
            if randomClipboard.descriptionLabel.text!.characters.count >= clipboardLongTextDef {
                randomClipboard.descriptionLabel.fontSize = clipboardLongTextFontSize
            } else {
                randomClipboard.descriptionLabel.fontSize = clipboardFontSize
            }
        }
        
        // Configure the rest of the clipboards. Note that if total lane numbers equal to tiles per round, this would not be run.
        for index in tiles.count..<laneNumbers.count {
            clipboards[index].matchingID = -1
            clipboards[index].descriptionLabel.text = ""
        }
    }
    
    // Get randomized lane numbers in an array.
    func getRandomLaneNumbers() -> [Int] {
        var laneNumbers = [Int]()
        for index in 0..<lanePositionsY.count {
            laneNumbers.append(index)
        }
        laneNumbers.shuffle()
        
        return laneNumbers
    }
    
    // Spawn the next tile and moving it towards clipboards.
    func spawnNextTile(tile: VocabMatchingTile) {
        // Spawn and move the tile.
        let destination = CGPoint(x: size.width * CGFloat(tileTouchesClipboardPosX), y: tile.position.y)
        let moveAction = SKAction.move(to: destination, duration: timeForTileToReachClipboard)
        tile.run(moveAction) {
            self.checkIfMatches(tile: tile)
        }
        
        addChild(tile)
    }
    
    // Check if the tile and the clipboard matches. If so, increment score. Then start the next round.
    func checkIfMatches(tile: VocabMatchingTile) {
        let tileLane = tile.laneNumber
        let clipboardAtLane = clipboards[tileLane]
        if tile.matchingID == clipboardAtLane.matchingID {
            // Is a match. Increment score.
            score += 1
            scoreLabel.text = String(score)
            
            // Blink the star of the clipboard to green.
            clipboardAtLane.texture = clipboardCorrectTexture
            clipboardAtLane.run(SKAction.wait(forDuration: clipboardStarBlinkAnimationDuration)) {
                clipboardAtLane.texture = self.clipboardTexture
            }
        } else {
            // Not a match, blink the star of the clipboard to red.
            clipboardAtLane.texture = clipboardWrongTexture
            clipboardAtLane.run(SKAction.wait(forDuration: clipboardStarBlinkAnimationDuration)) {
                clipboardAtLane.texture = self.clipboardTexture
            }
        }
        
        // Remove the current tile.
        tile.removeFromParent()
    }
    
    // After dragging and dropping a clipboard, check which lane is closer, and snap it to the lane and swap the positions. If it isn't dragged to the other lanes, no swapping will be performed, just snap it back to its original lane. The completion closure is for unit testing.
    func snapClipboardToClosestLane(droppedClipboard: VocabMatchingClipboard, dropLocationPosY: Double, completion: (()->())? = nil) {
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
                
                if completion != nil { completion!() }
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
                
                if completion != nil { completion!() }
            }
        }
    }
    
    // MARK: Touch Inputs
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // If the previous swapping animation isn't finished, return.
        if isSwapping { return }
        
        // Only the first touch is effective.
        guard let touch = touches.first else { return }
        
        // Check if the end game continue button is pressed.
        if isContinueButtonInteractable && continueButton.contains(touch.location(in: endSceneSprite)) {
            // End the game, transition to result view controller.
            viewController.endGame()
            
            return
        }
        
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
