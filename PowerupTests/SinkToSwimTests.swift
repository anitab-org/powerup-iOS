import XCTest
@testable import Powerup

class SinkToSwimTests: XCTestCase {
    
    // The game instance.
    var sinkToSwimGame: SinkToSwimGameScene!
    
    override func setUp() {
        super.setUp()
        
        // The size of the game is irrelevant for the tests.
        sinkToSwimGame = SinkToSwimGameScene(size: CGSize(width: 500.0, height: 500.0))
    }
    
    override func tearDown() {
        sinkToSwimGame = nil
        
        super.tearDown()
    }
    
    /** Test that questions are presented correctly. */
    func testQuestionConfiguration() {
        // Given (The mock questions, correctAnswer is irrelevant in this test.)
        let mockQuestions = [
            SinkToSwimQuestion(description: "Mock question one", correctAnswer: true),
            SinkToSwimQuestion(description: "Mock question two", correctAnswer: true),
            SinkToSwimQuestion(description: "Mock question three", correctAnswer: true)
        ]
        
        // Inject the mock questions to the game scene.
        sinkToSwimGame.questions = mockQuestions
        
        for mockQuestion in mockQuestions {
            
            // When
            sinkToSwimGame.showNextQuestion()
            
            // Then
            XCTAssertEqual(mockQuestion.description, sinkToSwimGame.questionLabel.text)
        }
    }
    
    /** Test that when correct/wrong answers are chosen, the score is correctly responded. */
    func testScoreChangeWhenAnswerIsChosen() {
        // Given (Question description is irrelevant in this test.)
        let mockQuestion = [
            SinkToSwimQuestion(description: "", correctAnswer: true),
            SinkToSwimQuestion(description: "", correctAnswer: true),
            SinkToSwimQuestion(description: "", correctAnswer: false),
            SinkToSwimQuestion(description: "", correctAnswer: false)
        ]
        
        // Inject the mock question to the game scene.
        sinkToSwimGame.questions = mockQuestion
        
        // Go to the first question.
        sinkToSwimGame.showNextQuestion()
        
        // Given
        sinkToSwimGame.score = 0
        sinkToSwimGame.currQuestion = 0
        
        // When (Choose correct answer when answer is true).
        sinkToSwimGame.answerChosen(choice: true)
        
        // Then
        XCTAssertEqual(sinkToSwimGame.score, 1)
        
        
        // Given
        sinkToSwimGame.score = 10
        sinkToSwimGame.currQuestion = 1
        
        // When (Choose the wrong answer when answer is true).
        sinkToSwimGame.answerChosen(choice: false)
        
        // Then (Score remains the same).
        XCTAssertEqual(sinkToSwimGame.score, 10)
        
        
        // Given
        sinkToSwimGame.score = 5
        sinkToSwimGame.currQuestion = 2
        
        // When (Choose the correct answer when answer is false).
        sinkToSwimGame.answerChosen(choice: false)
        
        // Then
        XCTAssertEqual(sinkToSwimGame.score, 6)
        
        
        // Given
        sinkToSwimGame.score = 8
        sinkToSwimGame.currQuestion = 3
        
        // When (Choose the wrong answer when answer is false).
        sinkToSwimGame.answerChosen(choice: true)
        
        // Then
        XCTAssertEqual(sinkToSwimGame.score, 8)
    }
    
    /** Test that tick timer correctly modifies the timer */
    func testTickTimer() {
        // Given
        sinkToSwimGame.timer = 25
        
        // When
        sinkToSwimGame.tickTimer()
        
        // Then
        XCTAssertEqual(sinkToSwimGame.timerLabel.text, "24")
    }
    
    /** Test that the boat sinks when raisingBoat == false, Test that the boat raises when raisingBoat == true */
    func testBoatSinkRaise() {
        // Given (Sinking)
        sinkToSwimGame.raisingBoat = false
        sinkToSwimGame.inTutorial = false
        
        var boatOriginalPositionY = sinkToSwimGame.avatarBoatSprite.position.y
        
        // Ensure that timer isn't zero.
        sinkToSwimGame.timer = 30
        
        // When (Update an arbitrary amount of frames and interval.)
        sinkToSwimGame.update(5.0)
        sinkToSwimGame.update(10.0)
        sinkToSwimGame.update(15.0)
        
        // Then (The boat should be less or equal to the original position. The equal condition occurs when it already reaches the lowest position.)
        XCTAssert(sinkToSwimGame.avatarBoatSprite.position.y <= boatOriginalPositionY)

        
        // Given (Raising)
        sinkToSwimGame.raisingBoat = true
        
        boatOriginalPositionY = sinkToSwimGame.avatarBoatSprite.position.y
        
        // When (Update an arbitrary amount of frames and interval.)
        sinkToSwimGame.update(23.0)
        sinkToSwimGame.update(30.0)
        
        // Then (The boat should be higher or equal to the original position. The equal condition occurs when it already reaches the highest position.)
        XCTAssert(sinkToSwimGame.avatarBoatSprite.position.y >= boatOriginalPositionY)
    }
    
    /** Test that the game ends when timer reaches 0 */
    func testTimerReachesZeroGameOver() {
        // Given
        sinkToSwimGame.timer = 0
        sinkToSwimGame.inTutorial = false
        
        // When (Update an arbitrary interval.)
        sinkToSwimGame.update(1.0)
        
        // Then
        XCTAssert(sinkToSwimGame.isGameOver)
    }
    
    /** Test that the game ends when the pointer drops to the bottom of the gauge */
    func testPointerDropGameOver() {
        // Given (arbitrary x pos, y pos at the bottom of the gauge.)
        sinkToSwimGame.waterGaugePointerSprite.position = CGPoint(x: 0.0, y: sinkToSwimGame.waterGaugeMinUnit * Double(sinkToSwimGame.waterGaugeSprite.size.height))
        sinkToSwimGame.inTutorial = false
        
        // When (Update arbitrary intervals.)
        sinkToSwimGame.update(1.0)
        sinkToSwimGame.update(2.0)
        
        // Then
        XCTAssert(sinkToSwimGame.isGameOver)
    }
}
