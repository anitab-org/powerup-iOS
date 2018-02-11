import XCTest
import SpriteKit

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
     Check that all the necessary nodes are added to the Minesweeper scene upon initialization.
     */
    func testInitialScreen() {
        // Given
        let skView = SKView()
        
        // When (Initialize the scene.)
        minesweeperGame.didMove(to: skView)
        
        // Then
        XCTAssertTrue(minesweeperGame.children.contains(minesweeperGame.backgroundImage))
        XCTAssertTrue(minesweeperGame.children.contains(minesweeperGame.resultBanner))
        XCTAssertTrue(minesweeperGame.children.contains(minesweeperGame.descriptionBanner))
        XCTAssertEqual(minesweeperGame.scoreLabel.text, minesweeperGame.scoreTextPrefix + String(minesweeperGame.score))
        XCTAssertTrue(minesweeperGame.children.contains(minesweeperGame.scoreLabelNode))
        XCTAssertTrue(minesweeperGame.children.contains(minesweeperGame.continueButton))
        for gridX in minesweeperGame.gameGrid {
            for box in gridX {
                // Make sure all of the boxes have been added
                XCTAssertTrue(minesweeperGame.children.contains(box))
            }
        }
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
    
    /**
     When the description banner is called, check that it is visible and check that the result banner is now hidden.
     */
    func testShowDescription() {
        // Given
        let resultBanner = minesweeperGame.resultBanner
        let descriptionBanner = minesweeperGame.descriptionBanner
        
        // When
        minesweeperGame.showDescription()
        
        // Then
        XCTAssertTrue(resultBanner.isHidden)
        XCTAssertFalse(descriptionBanner.isHidden)
        XCTAssertEqual(descriptionBanner.alpha, 0.0)
    }
    
    /**
     Check that the description banner has been hidden properly.
     */
    func testHideDescription() {
        // Given
        let descriptionBanner = minesweeperGame.descriptionBanner
        
        // When
        minesweeperGame.hideDescription()
        
        // Then
        XCTAssertTrue(descriptionBanner.isHidden)
    }
    
    /**
     Check that selecting a box updates the selectedBoxes, score, and currBox variables properly.
     */
    func testSelectBox() {
        // Given
        let originalSelectedBoxes = minesweeperGame.selectedBoxes
        let originalScore = minesweeperGame.score
        
        // When
        minesweeperGame.selectBox(box: guessingBox)
        
        // Then
        XCTAssertTrue(minesweeperGame.boxSelected)
        // There should be one additional box selected.
        XCTAssertEqual(minesweeperGame.selectedBoxes, originalSelectedBoxes + 1)
        XCTAssertEqual(minesweeperGame.currBox, nil)
    }
    
    /**
     Starting a new round should increment the round count, reset the number of selected boxes, and set the boxSelected variable to false.
     */
    func testNewRound() {
        // Given
        minesweeperGame.roundCount = 0
        
        // When
        minesweeperGame.newRound()
        
        // Then
        XCTAssertEqual(minesweeperGame.selectedBoxes, 0)
        XCTAssertEqual(minesweeperGame.roundCount, 1)
        XCTAssertFalse(minesweeperGame.boxSelected)
    }
    
    /**
     Check that when calling showAllResults(), the correct results banner is shown on the screen.
     */
    func testShowsCorrectResultsBanner() {
        // Test a successful game. The banner should have a successful texture.
        // Given
        var success = true
        
        // When
        minesweeperGame.showAllResults(isSuccessful: success)
        
        // Then
        XCTAssertEqual(minesweeperGame.resultBanner.texture, minesweeperGame.successBannerTexture)
        XCTAssertEqual(minesweeperGame.resultBanner.alpha, 0.0)
        XCTAssertFalse(minesweeperGame.resultBanner.isHidden)
        
        // Test a game that is not successful. The banner should have a failure texture.
        // Given
        success = false
        
        // When
        minesweeperGame.showAllResults(isSuccessful: success)
        
        // Then
        XCTAssertEqual(minesweeperGame.resultBanner.texture, minesweeperGame.failureBannerTexture)
        XCTAssertEqual(minesweeperGame.resultBanner.alpha, 0.0)
        XCTAssertFalse(minesweeperGame.resultBanner.isHidden)
    }
}
