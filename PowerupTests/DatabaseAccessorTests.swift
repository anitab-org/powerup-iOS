import XCTest
@testable import Powerup

class DatabaseAccessorTests: XCTestCase {
    
    var databaseAccessor: DatabaseAccessor!
    
    override func setUp() {
        databaseAccessor = DatabaseAccessor.sharedInstance
        
        // Use a different name from the original database so that the original database is not affected.
        databaseAccessor.databaseNameInFile = "testDatabase"
        
        // Initialize the database.
        do {
            try databaseAccessor.initializeDatabase()
        } catch _ {
            fatalError("Can't initialize database.")
        }
        
        super.setUp()
    }
    
    override func tearDown() {
        
        // Reset the database, so that further unit tests won't be affected by the previous ones.
        do {
            try databaseAccessor.resetDatabase()
        } catch _ {
            fatalError("Can't reset database.")
        }
        
        super.tearDown()
    }
    
    /**
      - Test that avatars can be correctly created and fetched to and from the database.
    */
    func testCreateGetAvatar() {
        // Given
        let avatar = Avatar(avatarID: databaseAccessor.avatarID, face: Accessory(type: .face), eyes: Accessory(type: .eyes), hair: Accessory(type: .hair), clothes: Accessory(type: .clothes), necklace: nil, glasses: nil, handbag: nil, hat: nil)
        var savedAvatar: Avatar
        
        // When
        do {
            try databaseAccessor.createAvatar(avatar)
            savedAvatar = try databaseAccessor.getAvatar()
        } catch _ {
            fatalError("Error save/get avatar from database.")
        }
        
        // Then
        XCTAssertEqual(avatar.id, savedAvatar.id)
        XCTAssertEqual(avatar.face.id, savedAvatar.face.id)
        XCTAssertEqual(avatar.clothes.id, savedAvatar.clothes.id)
        XCTAssertEqual(avatar.hair.id, savedAvatar.hair.id)
    }
    
    /**
      - Test that the accessories can be correctly bought (saved as purchased) and fetched to and from the database.
    */
    func testGetBoughtAccessory() {
        // Given
        let hair = Accessory(type: .hair, id: 1, imageName: "", points: 0, purchased: false)
        let necklace = Accessory(type: .necklace, id: 1, imageName: "", points: 0, purchased: false)
        let eyes = Accessory(type: .eyes, id: 1, imageName: "", points: 0, purchased: false)
        
        var savedHair: Accessory
        var savedNecklace: Accessory
        var savedEyes: Accessory
        
        // When
        do {
            // Save to database as bought.
            try databaseAccessor.boughtAccessory(accessory: hair)
            try databaseAccessor.boughtAccessory(accessory: necklace)
            try databaseAccessor.boughtAccessory(accessory: eyes)
            
            // Fetch from database.
            savedHair = try databaseAccessor.getAccessory(accessoryType: .hair, accessoryIndex: 1)
            savedNecklace = try databaseAccessor.getAccessory(accessoryType: .necklace, accessoryIndex: 1)
            savedEyes = try databaseAccessor.getAccessory(accessoryType: .eyes, accessoryIndex: 1)
        } catch _ {
            fatalError("Error saving and fetching accessories from database.")
        }
        
        // Then
        XCTAssertTrue(savedHair.purchased)
        XCTAssertTrue(savedNecklace.purchased)
        XCTAssertTrue(savedEyes.purchased)
    }
    
    /**
      - Test that scores can be correctly saved and fetched to and from the database.
    */
    func testGetSaveScore() {
        // Given
        let score = Score(karmaPoints: 0, healing: 10, strength: 20, telepathy: 30, invisibility: 1)
        
        var savedScore: Score
        
        // When
        do {
            // Need to have an avatar to save to score to.
            try databaseAccessor.createAvatar(Avatar())
            
            
            // Save the score to the database.
            try databaseAccessor.saveScore(score: score)
            
            // Get the saved score from the database.
            savedScore = try databaseAccessor.getScore()
        } catch _ {
            fatalError("Error saving and fetching score from database.")
        }
        
        // Then
        XCTAssertEqual(score.karmaPoints, savedScore.karmaPoints)
        XCTAssertEqual(score.healing, savedScore.healing)
        XCTAssertEqual(score.strength, savedScore.strength)
        XCTAssertEqual(score.telepathy, savedScore.telepathy)
        XCTAssertEqual(score.invisibility, savedScore.invisibility)
    }
    
    /**
      - Test that questions from the first scenario could be successfully fetched from the database.
    */
    func testGetQuestions() {
        
        // Given
        var questions: [Int: Question]
        
        // When
        do {
            questions = try databaseAccessor.getQuestions(of: 1)
        } catch _ {
            fatalError("Error fetching questions from database.")
        }
        
        // Then
        XCTAssertTrue(questions.count > 0)
    }
    
    /**
      - Test the answers of the first question could be successfully fetched from the database.
    */
    func testGetAnswers() {
        
        // Given
        var answers: [Answer]
        
        // When
        do {
            answers = try databaseAccessor.getAnswers(of: 1)
        } catch _ {
            fatalError("Error fetching answers from database.")
        }
        
        // Then
        XCTAssertTrue(answers.count > 0)
    }
    
}
