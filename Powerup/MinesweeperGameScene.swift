import SpriteKit

class MinesweeperGameScene: SKScene {
    
    // Make it as an array, so it is easy to add new entries.
    @objc var possiblityPercentages = [90.0]
    
    // MARK: Game Constants
    @objc let gridSizeCount = 5
    
    @objc let tutorialSceneImages = [
        "minesweeper_tutorial_1",
        "minesweeper_tutorial_2",
        "minesweeper_tutorial_3"
    ]
    
    // How many boxes could be selected each round.
    @objc let selectionMaxCount = 5
    
    // Colors of game UIs.
    @objc let uiColor = UIColor(red: 42.0 / 255.0, green: 203.0 / 255.0, blue: 211.0 / 255.0, alpha: 1.0)
    @objc let textColor = UIColor(red: 21.0 / 255.0, green: 124.0 / 255.0, blue: 129.0 / 255.0, alpha: 1.0)
    @objc let prosTextColor = UIColor(red: 105.0 / 255.0, green: 255.0 / 255.0, blue: 97.0 / 255.0, alpha: 1.0)
    @objc let consTextColor = UIColor(red: 255.0 / 255.0, green: 105.0 / 255.0, blue: 105.0 / 255.0, alpha: 1.0)
    
    // Animation constants.
    @objc let boxEnlargingScale = CGFloat(1.2)
    @objc let boxEnlargingDuration = 0.25
    @objc let buttonWaitDuration = 0.5
    @objc let boxFlipInterval = 0.2
    @objc let showAllBoxesInterval = 0.3
    @objc let boxEnlargingKey = "enlarge"
    @objc let boxShrinkingKey = "shrink"
    @objc let boxDarkening = SKAction.colorize(with: UIColor(white: 0.6, alpha: 0.8), colorBlendFactor: 1.0, duration: 0.2)
    @objc let fadeInAction = SKAction.fadeIn(withDuration: 0.8)
    @objc let fadeOutAction = SKAction.fadeOut(withDuration: 0.8)
    @objc let scoreTextPopScale = CGFloat(1.2)
    @objc let scoreTextPopDuraion = 0.25
    
    // These are relative to the size of the view, so they can be applied to different screen sizes.
    @objc let gridOffsetXRelativeToWidth = 0.31
    @objc let gridOffsetYRelativeToHeight = 0.0822
    @objc let gridSpacingRelativeToWidth = 0.0125
    @objc let boxSizeRelativeToWidth = 0.084
    
    @objc let continueButtonBottomMargin = 0.08
    @objc let continueButtonHeightRelativeToSceneHeight = 0.2
    @objc let continueButtonAspectRatio = 2.783
    
    @objc let prosDescriptionPosYRelativeToHeight = 0.77
    @objc let consDescriptionPosYRelativeToHeight = 0.33
    @objc let descriptionTextPosXReleativeToWidth = 0.53
    
    // Offset the text in y direction so that it appears in the center of the button.
    @objc let buttonTextOffsetY = -7.0
    @objc let scoreTextOffsetX = 10.0
    @objc let scoreTextOffsetY = 25.0
    
    // Fonts.
    @objc let scoreTextFontSize = CGFloat(20)
    @objc let buttonTextFontSize = CGFloat(18)
    @objc let descriptionTitleFontSize = CGFloat(24)
    @objc let descriptionFontSize = CGFloat(20)
    @objc let fontName = "Montserrat-Bold"
    
    @objc let buttonStrokeWidth = CGFloat(3)
    
    
    // These are the actual sizing and positioning, will be calculated in init()
    @objc let boxSize: Double
    @objc let gridOffsetX: Double
    @objc let gridOffsetY: Double
    @objc let gridSpacing: Double
    
    // Sprite nodes
    @objc let backgroundImage = SKSpriteNode(imageNamed: "minesweeper_background")
    @objc let resultBanner = SKSpriteNode()
    @objc let descriptionBanner = SKSpriteNode(imageNamed: "minesweeper_pros_cons_banner")
    @objc let continueButton = SKSpriteNode(imageNamed: "continue_button")
    
    // Label wrapper nodes
    @objc let scoreLabelNode = SKNode()
    @objc let prosLabelNode = SKNode()
    @objc let consLabelNode = SKNode()
    
    // Label nodes
    @objc let scoreLabel = SKLabelNode()
    @objc let prosLabel = SKLabelNode(text: "Pros text goes here...")
    @objc let consLabel = SKLabelNode(text: "Cons text goes here...")
    
    // Textures
    @objc let successBannerTexture = SKTexture(imageNamed: "success_banner")
    @objc let failureBannerTexture = SKTexture(imageNamed: "failure_banner")
    
    // TODO: Replace the temporary sprite.
    @objc let endGameText = "End Game"
    @objc let scoreTextPrefix = "Score: "
    
    // Layer index, aka. zPosition.
    @objc let backgroundLayer = CGFloat(-0.1)
    @objc let gridLayer = CGFloat(0.1)
    @objc let bannerLayer = CGFloat(0.2)
    @objc let uiLayer = CGFloat(0.3)
    @objc let uiTextLayer = CGFloat(0.4)
    @objc let tutorialSceneLayer = CGFloat(5)
    
    // MARK: Properties
    @objc var tutorialScene: SKTutorialScene!
    
    // Keep a reference to the view controller for end game transition.
    // (This is assigned in the MiniGameViewController class.)
    @objc var viewController: MiniGameViewController!
    
    // Holding each boxes
    @objc var gameGrid: [[GuessingBox]] = []
    @objc var roundCount = 0
    
    @objc var currBox: GuessingBox? = nil
    
    // Score. +1 if a successful box is chosen. +0 if a failed box is chosen.
    @objc var score = 0
    
    // Selected box count.
    @objc var selectedBoxes = 0
    
    // Avoid player interaction with boxes when they are animating.
    @objc var boxSelected: Bool = false
    
    // Avoid player interaction with boxes when the game is in tutorial scene.
    @objc var inTutorial = true
    
    // MARK: Constructor
    override init(size: CGSize) {
        
        // Positioning and sizing background image.
        backgroundImage.size = size
        backgroundImage.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        backgroundImage.zPosition = backgroundLayer
        
        // Positioning and sizing result banner.
        resultBanner.size = size
        resultBanner.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        resultBanner.zPosition = bannerLayer
        resultBanner.isHidden = true
        
        // Description Banner
        descriptionBanner.size = size
        descriptionBanner.anchorPoint = CGPoint.zero
        descriptionBanner.position = CGPoint.zero
        descriptionBanner.zPosition = bannerLayer
        descriptionBanner.isHidden = true
        
        // Score text
        scoreLabelNode.position = CGPoint(x: Double(size.width) - scoreTextOffsetX, y: Double(size.height) - scoreTextOffsetY)
        scoreLabelNode.zPosition = bannerLayer
        scoreLabel.position = CGPoint.zero
        scoreLabel.fontName = fontName
        scoreLabel.fontSize = scoreTextFontSize
        scoreLabel.zPosition = uiLayer
        scoreLabel.fontColor = uiColor
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabelNode.addChild(scoreLabel)
        
        // Continue button
        continueButton.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        continueButton.size = CGSize(width: CGFloat(continueButtonAspectRatio * continueButtonHeightRelativeToSceneHeight) * size.height, height: size.height * CGFloat(continueButtonHeightRelativeToSceneHeight))
        continueButton.position = CGPoint(x: size.width, y: size.height * CGFloat(continueButtonBottomMargin))
        continueButton.zPosition = uiLayer
        continueButton.isHidden = true
        
        // Pros label.
        prosLabelNode.position = CGPoint(x: Double(size.width) * descriptionTextPosXReleativeToWidth, y: Double(size.height) * prosDescriptionPosYRelativeToHeight)
        prosLabelNode.zPosition = bannerLayer
        prosLabel.position = CGPoint.zero
        prosLabel.horizontalAlignmentMode = .left
        prosLabel.fontName = fontName
        prosLabel.fontSize = descriptionFontSize
        prosLabel.fontColor = prosTextColor
        prosLabel.zPosition = uiLayer
        prosLabelNode.addChild(prosLabel)
        descriptionBanner.addChild(prosLabelNode)
        
        // Cons label.
        consLabelNode.position = CGPoint(x: Double(size.width) * descriptionTextPosXReleativeToWidth, y: Double(size.height) * consDescriptionPosYRelativeToHeight)
        consLabelNode.zPosition = bannerLayer
        consLabel.position = CGPoint.zero
        consLabel.horizontalAlignmentMode = .left
        consLabel.fontName = fontName
        consLabel.fontSize = descriptionFontSize
        consLabel.fontColor = consTextColor
        consLabel.zPosition = uiLayer
        consLabelNode.addChild(consLabel)
        descriptionBanner.addChild(consLabelNode)
        
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
    }
    
    
    // MARK: Functions
    
    // For initializing the nodes of the game.
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        
        // Add background image.
        addChild(backgroundImage)
        
        // Add banners.
        addChild(resultBanner)
        addChild(descriptionBanner)
        
        // Add score label.
        scoreLabel.text = scoreTextPrefix + String(score)
        addChild(scoreLabelNode)
        
        // Add continue button.
        addChild(continueButton)
        
        // Add boxes.
        for gridX in gameGrid {
            for box in gridX {
                addChild(box)
            }
        }
        
        // Show tutorial scene. After that, start the game.
        tutorialScene = SKTutorialScene(namedImages: tutorialSceneImages, size: size) {
            self.newRound()
            self.inTutorial = false
        }
        tutorialScene.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        tutorialScene.zPosition = tutorialSceneLayer
        addChild(tutorialScene)
    }
    
    /**
      Reset the grid for a new round.
      - Parameter: The possibility of the contrceptive method in percentage.
    */
    @objc func newRound() {
        let possibility = possiblityPercentages[roundCount]
        
        // Reset selected box count.
        selectedBoxes = 0
        
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
                
                let currBox = gameGrid[x][y]
                
                // Set whether it is a "success" box or a "failure" box.
                currBox.isCorrect = correctBoxes.popLast()!
                
                // Turn to back side.
                if currBox.onFrontSide {
                    currBox.changeSide()
                }
                
                // Reset color.
                currBox.color = UIColor.white
            }
        }
        
        roundCount += 1
        boxSelected = false
    }
    
    @objc func selectBox(box: GuessingBox) {
        boxSelected = true
        
        selectedBoxes += 1

        // Animations.
        let scaleBackAction = SKAction.scale(to: 1.0, duration: self.boxEnlargingDuration)
        let waitAction = SKAction.wait(forDuration: boxFlipInterval)
        let scaleBackAndWait = SKAction.sequence([scaleBackAction, waitAction])
        
        box.flip(scaleX: boxEnlargingScale) {
            
            // Scale the box back to the original scale.
            box.run(scaleBackAndWait) {
                
                // Check if the round should end.
                if !box.isCorrect {
                    // A failure box is chosen.
                    self.showAllResults(isSuccessful: false)
                } else {
                    // Update score. (With a pop animation)
                    self.scoreLabel.setScale(self.scoreTextPopScale)
                    self.score += 1
                    self.scoreLabel.text = self.scoreTextPrefix + String(self.score)
                    self.scoreLabel.run(SKAction.scale(to: 1.0, duration: self.scoreTextPopDuraion))
                    
                    // Check if max selection count is reached.
                    if self.selectedBoxes == self.selectionMaxCount {
                        self.showAllResults(isSuccessful: true)
                    } else {
                        // Reset boxSelected flag so that player could continue to select the next box.
                        self.boxSelected = false
                    }
                }
                
            }
        }
        
        currBox = nil
    }
    
    @objc func showAllResults(isSuccessful: Bool) {
        // Show result banner.
        resultBanner.texture = isSuccessful ? successBannerTexture : failureBannerTexture
        resultBanner.alpha = 0.0
        resultBanner.isHidden = false
        
        let waitAction = SKAction.wait(forDuration: showAllBoxesInterval)
        let bannerAnimation = SKAction.sequence([fadeInAction, waitAction])
        let buttonWaitAction = SKAction.wait(forDuration: buttonWaitDuration)
        
        // Fade in banner.
        resultBanner.run(bannerAnimation) {
            for x in 0..<self.gridSizeCount {
                for y in 0..<self.gridSizeCount {
                    let currBox = self.gameGrid[x][y]
                    
                    // Don't darken the selected box.
                    if currBox.onFrontSide { continue }
                    
                    // Darkens the color and flip the box.
                    currBox.run(self.boxDarkening) {
                        currBox.changeSide()
                        
                    }
                }
            }
            
            // Continue button. Change text and fade in.
            self.continueButton.alpha = 0.0
            self.continueButton.isHidden = false
            self.continueButton.run(SKAction.sequence([buttonWaitAction, self.fadeInAction]))
        }
        
    }
    
    // Called when "continue button" is pressed under the "result banner".
    @objc func showDescription() {
        
        // Fade out result banner.
        resultBanner.run(fadeOutAction) {
            self.resultBanner.isHidden = true
        }
        
        // Fade in description banner.
        descriptionBanner.isHidden = false
        descriptionBanner.alpha = 0.0
        descriptionBanner.run(fadeInAction) {
            
            // Fade in "next round" or "end game" button.
            self.continueButton.alpha = 0.0
            self.continueButton.isHidden = false
            self.continueButton.run(self.fadeInAction)
        }
    }
    
    // Called when "continue button" is pressed under the "description banner".
    @objc func hideDescription() {
        
        // Fade out description banner.
        descriptionBanner.run(fadeOutAction) {
            self.descriptionBanner.isHidden = true
        }
    }
    
    // MARK: Touch inputs
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if inTutorial { return }
        
        // Only the first touch is effective.
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        
        // Continue button pressed.
        if !continueButton.isHidden && continueButton.contains(location) {
            
            // Hide button. Avoid multiple touches.
            continueButton.isHidden = true
            
            // Check if it is the button of "result banner" or "description banner".
            if !resultBanner.isHidden {
                // Button in the result banner. Show description when tapped.
                showDescription()
            } else if roundCount < possiblityPercentages.count {
                // Not the last round, hide description banner and start a new round.
                newRound()
                hideDescription()
            } else {
                // End game.
                viewController.endGame()
            }
        }
        
        // Guessing box selected, not animating, and not selected yet.
        if let guessingBox = atPoint(location) as? GuessingBox, !boxSelected, !guessingBox.onFrontSide {
            currBox = guessingBox
            
            // Perform animation.
            guessingBox.removeAction(forKey: boxShrinkingKey)
            guessingBox.run(SKAction.scale(to: boxEnlargingScale, duration: boxEnlargingDuration), withKey: boxEnlargingKey)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if inTutorial { return }
        
        // Only the first touch is effective.
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        
        // Guessing box selected, equals to the current selected box, and no box is selected yet.
        if let guessingBox = atPoint(location) as? GuessingBox, guessingBox == currBox, !boxSelected {
            selectBox(box: guessingBox)
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
