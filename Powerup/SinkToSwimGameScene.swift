import SpriteKit

class SinkToSwimGameScene: SKScene {
    
    // TODO: Store the questions in the database.
    var questions: [SinkToSwimQuestion] = [
        SinkToSwimQuestion(description: "Test question 1, answer: true", correctAnswer: true),
        SinkToSwimQuestion(description: "Test question 2, answer: false", correctAnswer: false),
        SinkToSwimQuestion(description: "Test question 3, answer: false", correctAnswer: false),
        SinkToSwimQuestion(description: "Test question 4, answer: true", correctAnswer: true),
        SinkToSwimQuestion(description: "Test question 5, answer: false", correctAnswer: false),
        SinkToSwimQuestion(description: "Test question 6, answer: false", correctAnswer: false),
        SinkToSwimQuestion(description: "Test question 7, answer: false", correctAnswer: false),
        SinkToSwimQuestion(description: "Test question 8, answer: true", correctAnswer: true),
        SinkToSwimQuestion(description: "Test question 9, answer: false", correctAnswer: false),
        SinkToSwimQuestion(description: "Test question 10, answer: false", correctAnswer: false)
    ]
    
    // MARK: Constants
    let sinkingSpeedRelativeToGauge = 0.025
    
    let tutorialSceneImages = [
        "sink_to_swim_tutorial_1",
        "sink_to_swim_tutorial_2",
        "sink_to_swim_tutorial_3"
    ]
    
    // Sprite Positioning and sizing (relative to the size of game scene).
    // Water Gauge
    let waterGaugeWidth = 0.04
    let waterGaugeHeight = 0.9
    let waterGaugePosY = 0.5
    let waterGaugePosX = 0.075
    
    // Avatar Boat
    let avatarBoatWidth = 0.32
    let avatarBoatHeight = 0.59
    let avatarBoatPosY = 0.45
    let avatarBoatPosX = 0.33
    
    // This pos Y will be in sync with the pointer of the water gauge.
    let avatarBoatPosYToPointer = 0.5
    
    // Score Label
    let scoreLabelPosX = 0.73
    let scoreLabelPosY = 0.08
    
    // Question and True/False Box
    let questionBoxWidth = 0.38
    let questionBoxHeight = 0.635
    let questionBoxPosY = 0.46
    let questionBoxPosX = 0.75
    
    // The following four are relative to question box.
    let trueButtonWidth = 0.38
    let trueButtonHeight = 0.17
    let trueButtonPosY = -0.4
    let trueButtonPosX = -0.3
    
    // The following four are relative to question box.
    let falseButtonWidth = 0.43
    let falseButtonHeight = 0.17
    let falseButtonPosY = -0.4
    let falseButtonPosX = 0.28
    
    // The following four are relative to question box.
    let dontKnowButtonWidth = 0.1
    let dontKnowButtonHeight = 0.17
    let dontKnowButtonPosY = -0.4
    let dontKnowButtonPosX = -0.03
    
    // The following four are relative to question box.
    let questionLabelWidth = 0.84
    let questionLabelPosY = 0.4
    let questionLabelPosX = -0.02
    let questionLabelLeading = 25
    
    // Water Gauge Pointer
    let waterGaugePointerWidth = 0.1
    let waterGaugePointerHeight = 0.065
    
    // The following two are relative to Water Gauge.
    let waterGaugePointerPosX = 0.2
    let waterGaugePointerPosY = 0.4
    
    // Timer Box
    let timerWidth = 0.25
    let timerHeight = 0.08
    let timerPosY = 0.88
    let timerPosX = 0.75
    
    // The following two are relative to Timer Box.
    let timerLabelPosX = 0.15
    let timerLabelPosY = 0.01
    
    // Correct/Wrong Icon. (Relative to Question Box)
    let correctWrongIconWidth = 0.55
    let correctWrongIconHeight = 0.53
    let correctWrongIconPosY = 0.1
    let correctWrongIconPosX = 0.0
    
    // End scene labels.
    let endSceneCorrectLabelPosX = -0.01
    let endSceneCorrectLabelPosY = -0.06
    let endSceneWrongLabelPosX = 0.3
    let endSceneWrongLabelPosY = -0.06
    let endSceneScoreLabelPosX = -0.37
    let endSceneScoreLabelPosY = -0.12
    
    // Continue button.
    let continueButtonBottomMargin = 0.08
    let continueButtonHeightRelativeToSceneHeight = 0.15
    let continueButtonAspectRatio = 2.783
    
    // The unit of water gauge (The pointer will increase this unit whenever a correct answer is chosen). This is relative to the height of Water Gauge.
    let waterGaugeUnit = 0.13
    
    let waterGaugeMaxUnit = 0.42
    let waterGaugeMinUnit = -0.4
    
    let PointerToBoatRatio = 0.5
    
    // Colors
    let textColor = UIColor(colorLiteralRed: 21.0 / 255.0, green: 124.0 / 255.0, blue: 129.0 / 255.0, alpha: 1.0)
    let correctColor = UIColor(colorLiteralRed: 105.0 / 255.0, green: 255.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0)
    let wrongColor = UIColor(colorLiteralRed: 255.0 / 255.0, green: 105.0 / 255.0, blue: 105.0 / 255.0, alpha: 1.0)
    let scoreTextColor = UIColor.white
    
    // Fonts
    let fontName = "Montserrat-Bold"
    let questionFontSize = CGFloat(18)
    let scoreFontSize = CGFloat(22)
    let timerFontSize = CGFloat(17)
    let endSceneCountFontSize = CGFloat(55)
    let endSceneScoreFontSize = CGFloat(80)
    
    // Sprite nodes
    let backgroundSprite = SKSpriteNode(imageNamed: "sink_to_swim_background")
    let foregroundSprite = SKSpriteNode(imageNamed: "sink_to_swim_foreground")
    let waterGaugeSprite = SKSpriteNode(imageNamed: "sink_to_swim_gauge")
    let waterGaugePointerSprite = SKSpriteNode(imageNamed: "sink_to_swim_indicator")
    let avatarBoatSprite = SKSpriteNode(imageNamed: "sink_to_swim_boat_avatar")
    let timerSprite = SKSpriteNode(imageNamed: "sink_to_swim_timer")
    let questionBoxSprite = SKSpriteNode(imageNamed: "sink_to_swim_true_false_box")
    let trueButton = SKSpriteNode()
    let falseButton = SKSpriteNode()
    let dontKnowButton = SKSpriteNode()
    let correctWrongSprite = SKSpriteNode()
    let endSceneSprite = SKSpriteNode(imageNamed: "sink_to_swim_end_scene")
    let continueButton = SKSpriteNode(imageNamed: "continue_button")
    
    // Textures
    let correctIconTexture = SKTexture(imageNamed: "sink_to_swim_correct_icon")
    let wrongIconTexture = SKTexture(imageNamed: "sink_to_swim_wrong_icon")
    
    // Labels
    let scoreLabel = SKLabelNode()
    let timerLabel = SKLabelNode()
    let endSceneScoreLabel = SKLabelNode()
    let endSceneCorrectCountLabel = SKLabelNode()
    let endSceneWrongCountLabel = SKLabelNode()
    
    // Label wrapper nodes (For better control & positioning).
    let scoreLabelWrapper = SKNode()
    let timerLabelWrapper = SKNode()
    let endSceneScoreLabelWrapper = SKNode()
    let endSceneCorrectCountLabelWrapper = SKNode()
    let endSceneWrongCountLabelWrapper = SKNode()
    
    let scoreLabelPrefix = "Score: "
    
    // Layers (zPosition)
    let backgroundLayer = CGFloat(-0.1)
    let avatarBoatLayer = CGFloat(0.1)
    let foregroundLayer = CGFloat(0.2)
    let uiLayer = CGFloat(0.3)
    let uiTextLayer = CGFloat(0.4)
    let frontLayer = CGFloat(0.5)
    let endSceneLayer = CGFloat(1.5)
    let tutorialSceneLayer = CGFloat(5)
    
    // Animations
    let questionFadeInTime = 0.3
    let questionFadeOutTime = 0.2
    let correctWrongSpriteStayTime = 0.5
    let boatRaiseDuration = 0.4
    let boatRotateAngle = 20.0
    let boatRotateDuration = 4.0
    let endScenePauseDuration = 1.0
    let endSceneFadeInDuration = 1.0
    
    // MARK: Properties
    var questionLabel: SKMultilineLabel!
    var tutorialScene: SKTutorialScene!
    
    // Only when the question is presented can the player choose the answer.
    var questionPresented = false
    
    // Index of the current water level.
    var currWaterLevel: Int!
    
    // Index of the current question.
    var currQuestion = -1
    
    // Current score.
    var score = 0
    var wrongCount = 0
    
    // Current timer (Start counting down from this value).
    var timer = 40
    
    // Disable buttons and update function if the game is over.
    var isGameOver = false
    
    // Timestamp of the previous frame.
    var timestamp: Double? = nil
    
    var raisingBoat = false
    
    // To avoid sinking the boat while the game is in tutorial scene.
    var inTutorial = true
    
    // Continue button is only interactable after the ending scene is fully faded in.
    var continueButtonInteractable = false
    
    // Keep a reference to the view controller for end game transition. (This is assigned in the MiniGameViewController class).
    var viewController: MiniGameViewController!
    
    // MARK: Constructors
    override init(size: CGSize) {
        super.init(size: size)
        
        let gameWidth = Double(size.width)
        let gameHeight = Double(size.height)
        
        // Positioning and sizing background/foreground image.
        backgroundSprite.size = size
        backgroundSprite.position = CGPoint(x: gameWidth / 2.0, y: gameHeight / 2.0)
        backgroundSprite.zPosition = backgroundLayer
        
        foregroundSprite.size = size
        foregroundSprite.position = CGPoint(x: gameWidth / 2.0, y: gameHeight / 2.0)
        foregroundSprite.zPosition = foregroundLayer
        
        // Positioning and sizing avatar and boat.
        avatarBoatSprite.size = CGSize(width: gameWidth * avatarBoatWidth, height: gameHeight * avatarBoatHeight)
        avatarBoatSprite.position = CGPoint(x: gameWidth * avatarBoatPosX, y: gameHeight * avatarBoatPosY)
        avatarBoatSprite.zPosition = avatarBoatLayer
        
        // Positioning and sizing water gauge & water gauge pointer.
        waterGaugeSprite.size = CGSize(width: gameWidth * waterGaugeWidth, height: gameHeight * waterGaugeHeight)
        waterGaugeSprite.position = CGPoint(x: gameWidth * waterGaugePosX, y: gameHeight * waterGaugePosY)
        waterGaugeSprite.zPosition = uiLayer
        
        waterGaugePointerSprite.size = CGSize(width: gameWidth * waterGaugePointerWidth, height: gameHeight * waterGaugePointerHeight)
        waterGaugeSprite.addChild(waterGaugePointerSprite)
        waterGaugePointerSprite.position = CGPoint(x: waterGaugeSprite.size.width * CGFloat(waterGaugePointerPosX), y: waterGaugeSprite.size.height * CGFloat(waterGaugePointerPosY))
        waterGaugePointerSprite.zPosition = uiLayer
        
        // Positioning and sizing question box.
        questionBoxSprite.size = CGSize(width: gameWidth * questionBoxWidth, height: gameHeight * questionBoxHeight)
        questionBoxSprite.position = CGPoint(x: gameWidth * questionBoxPosX, y: gameHeight * questionBoxPosY)
        questionBoxSprite.zPosition = uiTextLayer
        
        // Positioning and sizing true/false buttons.
        questionBoxSprite.addChild(trueButton)
        trueButton.size = CGSize(width: questionBoxSprite.size.width * CGFloat(trueButtonWidth), height: questionBoxSprite.size.height * CGFloat(trueButtonHeight))
        trueButton.position = CGPoint(x: questionBoxSprite.size.width * CGFloat(trueButtonPosX), y: questionBoxSprite.size.height * CGFloat(trueButtonPosY))
        trueButton.zPosition = uiLayer
        trueButton.color = UIColor.clear
        
        questionBoxSprite.addChild(falseButton)
        falseButton.size = CGSize(width: questionBoxSprite.size.width * CGFloat(falseButtonWidth), height: questionBoxSprite.size.height * CGFloat(falseButtonHeight))
        falseButton.position = CGPoint(x: questionBoxSprite.size.width * CGFloat(falseButtonPosX), y: questionBoxSprite.size.height * CGFloat(falseButtonPosY))
        falseButton.zPosition = uiLayer
        falseButton.color = UIColor.clear
        
        questionBoxSprite.addChild(dontKnowButton)
        dontKnowButton.size = CGSize(width: questionBoxSprite.size.width * CGFloat(dontKnowButtonWidth), height: questionBoxSprite.size.height * CGFloat(dontKnowButtonHeight))
        dontKnowButton.position = CGPoint(x: questionBoxSprite.size.width * CGFloat(dontKnowButtonPosX), y: questionBoxSprite.size.height * CGFloat(dontKnowButtonPosY))
        dontKnowButton.zPosition = uiLayer
        dontKnowButton.color = UIColor.clear
        
        // Positioning question label.
        questionLabel = SKMultilineLabel(text: "", labelWidth: Int(CGFloat(questionLabelWidth) * questionBoxSprite.size.width), pos: CGPoint.zero, fontName: fontName, fontSize: questionFontSize, fontColor: textColor,leading: questionLabelLeading)
        questionLabel.zPosition = uiTextLayer
        questionBoxSprite.addChild(questionLabel)
        questionLabel.pos =  CGPoint(x: questionBoxSprite.size.width * CGFloat(questionLabelPosX), y: questionBoxSprite.size.height * CGFloat(questionLabelPosY))
        
        // Positioning and sizing timer.
        timerSprite.size = CGSize(width: gameWidth * timerWidth, height: gameHeight * timerHeight)
        timerSprite.position = CGPoint(x: gameWidth * timerPosX, y: gameHeight * timerPosY)
        timerSprite.zPosition = uiTextLayer
        
        // Positioning and configuring font properties of score label.
        scoreLabel.text = scoreLabelPrefix + String(score)
        scoreLabel.fontColor = scoreTextColor
        scoreLabel.fontSize = scoreFontSize
        scoreLabel.fontName = fontName
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.zPosition = uiTextLayer
        
        scoreLabelWrapper.position = CGPoint(x: gameWidth * scoreLabelPosX, y: gameHeight * scoreLabelPosY)
        scoreLabelWrapper.zPosition = uiTextLayer
        scoreLabelWrapper.addChild(scoreLabel)
        
        // Positioning and configuring font properties of timer label.
        timerLabel.text = String(timer)
        timerLabel.fontColor = textColor
        timerLabel.fontSize = timerFontSize
        timerLabel.fontName = fontName
        timerLabel.horizontalAlignmentMode = .center
        timerLabel.verticalAlignmentMode = .center
        timerLabel.zPosition = uiTextLayer
        
        timerLabelWrapper.position = CGPoint(x: timerSprite.size.width * CGFloat(timerLabelPosX), y: timerSprite.size.height * CGFloat(timerLabelPosY))
        timerLabelWrapper.zPosition = uiTextLayer
        timerLabelWrapper.addChild(timerLabel)
        timerSprite.addChild(timerLabelWrapper)
        
        // Sizing and positioning correct/wrong icon.
        correctWrongSprite.size = CGSize(width: questionBoxSprite.size.width * CGFloat(correctWrongIconWidth), height: questionBoxSprite.size.height * CGFloat(correctWrongIconHeight))
        correctWrongSprite.position = CGPoint(x: questionBoxSprite.size.width * CGFloat(correctWrongIconPosX), y: questionBoxSprite.size.height * CGFloat(correctWrongIconPosY))
        correctWrongSprite.zPosition = frontLayer
        questionBoxSprite.addChild(correctWrongSprite)
        
        // End scene.
        endSceneSprite.size = CGSize(width: gameWidth, height: gameHeight)
        endSceneSprite.position = CGPoint(x: gameWidth / 2.0, y: gameHeight / 2.0)
        endSceneSprite.zPosition = endSceneLayer
        
        // End scene labels.
        // Correct count label.
        endSceneSprite.addChild(endSceneCorrectCountLabelWrapper)
        endSceneCorrectCountLabelWrapper.position = CGPoint(x: gameWidth * endSceneCorrectLabelPosX, y: gameHeight * endSceneCorrectLabelPosY)
        endSceneCorrectCountLabelWrapper.zPosition = uiTextLayer
        endSceneCorrectCountLabelWrapper.addChild(endSceneCorrectCountLabel)
        
        endSceneCorrectCountLabel.fontName = fontName
        endSceneCorrectCountLabel.fontColor = correctColor
        endSceneCorrectCountLabel.fontSize = endSceneCountFontSize
        endSceneCorrectCountLabel.horizontalAlignmentMode = .center
        endSceneCorrectCountLabel.verticalAlignmentMode = .center
        
        // Wrong count label.
        endSceneSprite.addChild(endSceneWrongCountLabelWrapper)
        endSceneWrongCountLabelWrapper.position = CGPoint(x: gameWidth * endSceneWrongLabelPosX, y: gameHeight * endSceneWrongLabelPosY)
        endSceneWrongCountLabelWrapper.zPosition = uiTextLayer
        endSceneWrongCountLabelWrapper.addChild(endSceneWrongCountLabel)
        
        endSceneWrongCountLabel.fontName = fontName
        endSceneWrongCountLabel.fontColor = wrongColor
        endSceneWrongCountLabel.fontSize = endSceneCountFontSize
        endSceneWrongCountLabel.horizontalAlignmentMode = .center
        endSceneWrongCountLabel.verticalAlignmentMode = .center
        
        // Score label.
        endSceneSprite.addChild(endSceneScoreLabelWrapper)
        endSceneScoreLabelWrapper.position = CGPoint(x: gameWidth * endSceneScoreLabelPosX, y: gameHeight * endSceneScoreLabelPosY)
        endSceneScoreLabelWrapper.zPosition = uiTextLayer
        endSceneScoreLabelWrapper.addChild(endSceneScoreLabel)
        
        endSceneScoreLabel.fontName = fontName
        endSceneScoreLabel.fontColor = textColor
        endSceneScoreLabel.fontSize = endSceneScoreFontSize
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented.")
    }
    
    // MARK: Functions
    
    // For initializing the nodes of the game.
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        
        // Add background/foreground image.
        addChild(backgroundSprite)
        addChild(foregroundSprite)
        
        // Add water gauge.
        addChild(waterGaugeSprite)
        
        // Add avatar boat.
        addChild(avatarBoatSprite)
        
        // Add question box.
        addChild(questionBoxSprite)
        
        // Add timer box.
        addChild(timerSprite)
        
        // Add score label.
        addChild(scoreLabelWrapper)
        
        // Add end scene.
        addChild(endSceneSprite)
        
        // Shuffle the questions.
        questions.shuffle()
        
        // Start the game by showing the first question.
        showNextQuestion()
        
        // Start the wobbling animation of the boat.
        startBoatWobblingAnimation()
        
        if !UserDefaults.standard.bool(forKey: "SwimTutsViewed") {
            // Show tutorial scene. After that, start the game (aka start the timer).
            tutorialScene = SKTutorialScene(namedImages: tutorialSceneImages, size: size) {
                let timerTickAction = SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.run({self.tickTimer()})])
                self.run(SKAction.repeatForever(timerTickAction), withKey: "timer_tick")
                self.inTutorial = false
            }
            tutorialScene.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
            tutorialScene.zPosition = tutorialSceneLayer
            addChild(tutorialScene)
            UserDefaults.standard.set(true, forKey: "SwimTutsViewed")
        } else {
            // It is not the user's 1st time playing the game, so skip tutorials
            let timerTickAction = SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.run({self.tickTimer()})])
            self.run(SKAction.repeatForever(timerTickAction), withKey: "timer_tick")
            self.inTutorial = false
        }
    }
    
    // Being called every frame.
    override func update(_ currentTime: TimeInterval) {
        if inTutorial { return }
        
        // Check if timer reaches zero.
        if timer <= 0 {
            
            // Game over.
            gameOver(drowned: false)
        }
        
        if isGameOver { return }
        
        // The first frame of the game. Initialize timestamp.
        if timestamp == nil {
            timestamp = currentTime
            return
        } else {
            let timePassed = currentTime - timestamp!
            timestamp! = currentTime
            
            // Update water pointer.
            var waterPointerNewPosY: Double
            var avatarBoatNewPosY: Double
            if raisingBoat {
                // Raise the boat.
                
                // Raising speed is equal to (water gauge unit / question transition animation time).
                let raisingSpeed = waterGaugeUnit * Double(waterGaugeSprite.size.height) / (questionFadeInTime + questionFadeOutTime + correctWrongSpriteStayTime)
                
                waterPointerNewPosY = Double(waterGaugePointerSprite.position.y) + timePassed * raisingSpeed
                
                avatarBoatNewPosY = Double(avatarBoatSprite.position.y) + timePassed * raisingSpeed * PointerToBoatRatio
            } else {
                // Drown the boat.
                waterPointerNewPosY = Double(waterGaugePointerSprite.position.y) - timePassed * sinkingSpeedRelativeToGauge * Double(waterGaugeSprite.size.height)
                
                avatarBoatNewPosY = Double(avatarBoatSprite.position.y) - timePassed * sinkingSpeedRelativeToGauge * Double(waterGaugeSprite.size.height) * PointerToBoatRatio
            }
            
            // Set the position of the pointer. Ensure that the pointer won't go out of the gauge.
            let minPosY = waterGaugeMinUnit * Double(waterGaugeSprite.size.height)
            let maxPosY = waterGaugeMaxUnit * Double(waterGaugeSprite.size.height)
            var ending = false
            
            if waterPointerNewPosY < minPosY {
                waterPointerNewPosY = minPosY
                ending = true
            } else if waterPointerNewPosY > maxPosY {
                waterPointerNewPosY = maxPosY
            } else {
                // Update the position of the boat.
                avatarBoatSprite.position = CGPoint(x: Double(avatarBoatSprite.position.x), y: avatarBoatNewPosY)
            }
            
            // Update the position of the pointer.
            waterGaugePointerSprite.position = CGPoint(x: Double(waterGaugePointerSprite.position.x), y: waterPointerNewPosY)
            
            // If the new posY goes below the min y-position, game over.
            if ending {
                gameOver(drowned: true)
                return
            }
        }
    }
    
    // Tick the timer.
    func tickTimer() {
        timer -= 1
        timerLabel.text = String(self.timer)
    }
    
    // Start animating the boat.
    func startBoatWobblingAnimation() {
        let deg2rad = .pi / 180.0
        
        let clockwiseRotation = SKAction.rotate(byAngle: CGFloat(-boatRotateAngle * deg2rad), duration: boatRotateDuration / 4.0)
        let counterclockwiseRotation = SKAction.rotate(byAngle: CGFloat(boatRotateAngle * deg2rad), duration: boatRotateDuration / 4.0)
        
        // Tilt to the right -> back to upstraight -> tilt to the left -> back to upstraight.
        let wobblingAnimation = SKAction.sequence([clockwiseRotation, counterclockwiseRotation, counterclockwiseRotation, clockwiseRotation])
        
        // Repeat the animation pattern forever.
        avatarBoatSprite.run(SKAction.repeatForever(wobblingAnimation))
    }
    
    // Transition to game over scene. Determine the game is successful by whether the boat is drowned or not. (currently, the result is the same whether the game is successful or not. Just keep the "drowned" parameter so that future changes could be done easily.)
    func gameOver(drowned: Bool) {
        isGameOver = true
        
        // Stop the timer ticking animation.
        removeAction(forKey: "timer_tick")
        
        // Pause for some time.
        run(SKAction.wait(forDuration: endScenePauseDuration)) {
            
            // Set the score label, correct counts, and wrong counts.
            self.endSceneScoreLabel.text = String(self.score)
            self.endSceneCorrectCountLabel.text = String(self.score)
            self.endSceneWrongCountLabel.text = String(self.wrongCount)
            
            // Fade in ending scene.
            self.endSceneSprite.alpha = 0.0
            self.endSceneSprite.isHidden = false
            self.endSceneSprite.run(SKAction.fadeIn(withDuration: self.endSceneFadeInDuration)) {
                self.continueButtonInteractable = true
            }
        }
    }
    
    // Fade-in the next question.
    func showNextQuestion() {
        currQuestion += 1
        
        // Configure the text.
        questionLabel.text = questions[currQuestion].description
        
        // Fade-in the questions.
        questionLabel.alpha = 0.0
        questionLabel.isHidden = false
        questionLabel.run(SKAction.fadeIn(withDuration: questionFadeInTime)) {
            self.raisingBoat = false
        }
        
        // Set questionPresented to true (so that the true/false buttons could be pressed).
        questionPresented = true
    }
    
    // Reveal the correct answer, update score, update boat position. If Dont Know Button is pressed, choice is passed as nil.
    func answerChosen(choice: Bool?) {
        
        // True/False Button is pressed.
        if choice != nil {
            let isCorrect = questions[currQuestion].correctAnswer == choice
            
            // Update score.
            if isCorrect {
                score += 1
            } else {
                wrongCount += 1
            }
            scoreLabel.text = scoreLabelPrefix + String(score)
            
            // Show the wrong / correct icon.
            correctWrongSprite.texture = isCorrect ? correctIconTexture : wrongIconTexture
            
            // If the answer if correct, raise the boat (until the next question is presented).
            raisingBoat = isCorrect
        }
        
        // Wait a certain amount of time, fade out the text. and transition to the next question.
        self.run(SKAction.wait(forDuration: correctWrongSpriteStayTime)) {
            
            // Hide the icon.
            self.correctWrongSprite.texture = nil
            
            // Fade out the question.
            self.questionLabel.run(SKAction.fadeOut(withDuration: self.questionFadeOutTime)) {
                self.questionLabel.isHidden = true
                
                // Check if there're still questions, if so, show the next question.
                if self.currQuestion < self.questions.count - 1 {
                    self.showNextQuestion()
                } else {
                    // If no question is left, the game is over.
                    self.gameOver(drowned: false)
                }
            }
        }
    }
    
    // MARK: Touch Inputs
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if inTutorial { return }
        
        // Only the first touch is effective.
        guard let touch = touches.first else { return }
        
        if isGameOver {
            
            // Check if continue button is tapped.
            if continueButtonInteractable && continueButton.contains(touch.location(in: endSceneSprite)) {
                
                // End game.
                viewController.endGame()
            }
            
            // Disable true/false/dont know buttons if the game is over.
            return
        }
        
        let location = touch.location(in: questionBoxSprite)
        
        // Only when the question is presented can the player choose the answer.
        if !questionPresented { return }
        
        if trueButton.contains(location) {
            // True Button is tapped.
            answerChosen(choice: true)
            
            // Prevent multiple touches.
            questionPresented = false
        } else if falseButton.contains(location) {
            // False Button is tapped.
            answerChosen(choice: false)
            
            // Prevent multiple touches.
            questionPresented = false
        } else if dontKnowButton.contains(location) {
            // Dont Know Button is tapped.
            answerChosen(choice: nil)
            
            // Prevent multiple touches.
            questionPresented = false
        }
    }
}
