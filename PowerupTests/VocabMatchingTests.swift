import XCTest
@testable import Powerup

class VocabMatchingTests: XCTestCase {
    var vocabMatchingGame: VocabMatchingGameScene!
    
    override func setUp() {
        super.setUp()
        
        // Initialize game scene. The size could be any number aside from zero (some tests require using the width/height of the game scene).
        vocabMatchingGame = VocabMatchingGameScene(size: CGSize(width: 1.0, height: 1.0))
    }
    
    override func tearDown() {
        
        vocabMatchingGame = nil
        super.tearDown()
    }

    /** Test that matches are correctly checked. */
    func testCheckIfMatches() {
        
        // Given
        vocabMatchingGame.clipboards = [
            VocabMatchingClipboard(texture: nil, size: CGSize.zero, matchingID: 2, description: ""),
            VocabMatchingClipboard(texture: nil, size: CGSize.zero, matchingID: 1, description: "")
        ]
        vocabMatchingGame.score = 0
        let testingTile = VocabMatchingTile(matchingID: 2, textureName: "", descriptionText: "", size: CGSize.zero)
        testingTile.laneNumber = 0
        
        // When
        vocabMatchingGame.checkIfMatches(tile: testingTile)
        
        // Then
        XCTAssert(vocabMatchingGame.score == 1)
        
        
        // Test the score stays the same when mismatched.
        // Given
        testingTile.laneNumber = 1
        testingTile.matchingID = 3
        vocabMatchingGame.score = 10
        
        // When
        vocabMatchingGame.checkIfMatches(tile: testingTile)
        
        // Then
        XCTAssert(vocabMatchingGame.score == 10)
        
    }
    
    /** Test that the clipboard snaps back to its original position Y if it is not dragged far enough. */
    func testClipboardSnapBackToOriginalLane() {
        // Given
        vocabMatchingGame.lanePositionsY = [1.0, 3.0, 5.0]
        
        // The clipboards. All fields except the positions are relevant to the test.
        vocabMatchingGame.clipboards = [
            VocabMatchingClipboard(texture: nil, size: CGSize.zero, matchingID: 0, description: ""),
            VocabMatchingClipboard(texture: nil, size: CGSize.zero, matchingID: 0, description: ""),
            VocabMatchingClipboard(texture: nil, size: CGSize.zero, matchingID: 0, description: "")
        ]
        
        let gameHeight = Double(vocabMatchingGame.size.height)
        
        // Testing the second clipboard.
        let testingClipboard = vocabMatchingGame.clipboards[1]
        vocabMatchingGame.addChild(testingClipboard)
        testingClipboard.position = CGPoint(x: 0.0, y: vocabMatchingGame.lanePositionsY[1] * gameHeight)
        
        // When
        vocabMatchingGame.snapClipboardToClosestLane(droppedClipboard: testingClipboard, dropLocationPosY: gameHeight * 3.9) {
            
            // Then
            XCTAssert(testingClipboard.position.y.isEqual(to: CGFloat(gameHeight * self.vocabMatchingGame.lanePositionsY[1])))
        }
        
    }
    
    /** Test that the clipboards could be correctly swapped when dragged. */
    func testClipboardSwap() {
        // Given
        vocabMatchingGame.lanePositionsY = [2.0, 4.0, 6.0]
        vocabMatchingGame.clipboards = [
            VocabMatchingClipboard(texture: nil, size: CGSize.zero, matchingID: 0, description: ""),
            VocabMatchingClipboard(texture: nil, size: CGSize.zero, matchingID: 0, description: ""),
            VocabMatchingClipboard(texture: nil, size: CGSize.zero, matchingID: 0, description: "")
        ]
        
        let gameHeight = Double(vocabMatchingGame.size.height)
        let clipboardDragged = vocabMatchingGame.clipboards[0]
        let clipboardSwapped = vocabMatchingGame.clipboards[2]
        
        vocabMatchingGame.addChild(clipboardDragged)
        vocabMatchingGame.addChild(clipboardSwapped)
        
        clipboardDragged.position = CGPoint(x: 0.0, y: vocabMatchingGame.lanePositionsY[0] * gameHeight)
        clipboardSwapped.position = CGPoint(x: 0.0, y: vocabMatchingGame.lanePositionsY[2] * gameHeight)
        
        // When (drag the first clipboard [0] near the position of the third clipboard [2])
        vocabMatchingGame.snapClipboardToClosestLane(droppedClipboard: clipboardDragged, dropLocationPosY: 5.5) {
            
            // Then (Check the index of the array for the clipboards are swapped.)
            XCTAssert(clipboardSwapped === self.vocabMatchingGame.clipboards[2])
            XCTAssert(clipboardDragged === self.vocabMatchingGame.clipboards[0])
        }
    }
    
    /** Test that the game ends after it reaches the last round. */
    func testGameEnds() {
        // Given
        let maxRound = vocabMatchingGame.totalRounds
        vocabMatchingGame.currRound = maxRound - 1
        
        // When
        vocabMatchingGame.nextRound() {
            // Then
            XCTAssert(!self.vocabMatchingGame.endSceneSprite.isHidden)
        }
    }
}
