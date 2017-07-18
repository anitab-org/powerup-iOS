import XCTest
@testable import Powerup

/** Tests for database model classes. */
class ModelClassTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /**
      - Test operator+ and operator- of Score
    */
    func testScoreOperators() {
        // Given
        let score1 = Score(karmaPoints: 1, healing: 3, strength: 5, telepathy: 7, invisibility: 10)
        let score2 = Score(karmaPoints: 1, healing: 2, strength: 4, telepathy: 3, invisibility: 2)
        
        // When
        let addition = score1 + score2
        let subtraction = score1 - score2
        
        // Then
        XCTAssertEqual(addition.karmaPoints, 2)
        XCTAssertEqual(addition.healing, 5)
        XCTAssertEqual(addition.strength, 9)
        XCTAssertEqual(addition.telepathy, 10)
        XCTAssertEqual(addition.invisibility, 12)
        
        XCTAssertEqual(subtraction.karmaPoints, 0)
        XCTAssertEqual(subtraction.healing, 1)
        XCTAssertEqual(subtraction.strength, 1)
        XCTAssertEqual(subtraction.telepathy, 4)
        XCTAssertEqual(subtraction.invisibility, 8)
    }
    
    /**
      - Test that the correct image is configured for accessories.
    */
    func testAccessoryImages() {
        // Given
        let clothesImageName = "cloth1"
        let hairImageName = "hair2"
        
        // When
        // Only the imageName member is of interest in this test.
        let clothes = Accessory(type: .clothes, id: 1, imageName: clothesImageName, points: 0, purchased: false)
        let hair = Accessory(type: .hair, id: 1, imageName: hairImageName, points: 0, purchased: false)
        
        // Then
        XCTAssertNotNil(clothes.image, "Clothes's image shouldn't be nil.")
        XCTAssertEqual(clothes.image, UIImage(named: clothesImageName))
        
        XCTAssertNotNil(hair.image, "Hair's image shouldn't be nil.")
        XCTAssertEqual(hair.image, UIImage(named: hairImageName))
    }
}
