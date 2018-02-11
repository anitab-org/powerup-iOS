import XCTest

@testable import Powerup

class MinesweeperTests: XCTestCase {
    
    var guessingBox: GuessingBox!
    var minesweeperGame: MinesweeperGameScene!
    
    override func setUp() {
        
        // An arbitrary guessing box instance.
        guessingBox = GuessingBox(xOfGrid: 0, yOfGrid: 0, isCorrect: true, size: CGSize.zero)
        
        // Mine sweeper game scene class (size is irrelevant in this test class).
        minesweeperGame = MinesweeperGameScene(size: CGSize.zero)
        
        super.setUp()
    }
    
    override func tearDown() {
        guessingBox = nil
        minesweeperGame = nil
        
        super.tearDown()
    }
    
    /**
      Check that the box is correctly flipped to the other side after calling changeSide().
    */
    func testGuessingBoxChangeSide() {
        // Given
        guessingBox.onFrontSide = false
        
        // When
        guessingBox.changeSide()
        
        // Then
        XCTAssert(guessingBox.onFrontSide == true)
        
        let checkTexture = (guessingBox.texture == guessingBox.failureTexture || guessingBox.texture == guessingBox.successTexture)
        XCTAssert(checkTexture)
    }
    
    /**
      Check that the box is correctly flipped to the other side after calling flip(scaleX:completion:)
    */
    func testGuessingBoxAnimatedFlip() {
        // Given
        guessingBox.onFrontSide = true
        
        // When
        guessingBox.flip(scaleX: CGFloat(0)) {
            
            // Then
            XCTAssert(self.guessingBox.onFrontSide == false)
            
            XCTAssert(self.guessingBox.texture == self.guessingBox.backsideTexture)
        }
        
    }
    
    /**
      Check if the success/failure ratio of the grid is set according to the probability of the contraceptive method.
    */
    func testMinesweeperGridProbability() {
        
        // Given
        minesweeperGame.possiblityPercentages = [0.0, 100.0, 30.4, 76.3]
        let correctAnswers = [0, 25, 7, 19]
        
        for (index, _) in minesweeperGame.possiblityPercentages.enumerated() {
            
            // When
            minesweeperGame.roundCount = index
            minesweeperGame.newRound()
            
            // Then
            var greenBoxes = 0
            for row in minesweeperGame.gameGrid {
                for box in row {
                    if box.isCorrect {
                        greenBoxes += 1
                    }
                }
            }
            
            XCTAssert(correctAnswers[index] == greenBoxes)
            
        }
        
    }
}
