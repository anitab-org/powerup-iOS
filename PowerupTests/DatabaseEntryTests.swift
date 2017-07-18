import XCTest
@testable import Powerup

/** Test that the entries of the database is valid. */
class DatabaseEntryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /**
      - Test that all answers transition to a valid question upon chosen.
    */
    func testAllAnswersTransitionToAValidQuestion() {
        
        // The scenarios added to database. (Should expand this when a new scenario is added to the game.)
        let availableScenarioIDs = [1, 2, 6, 5, 7]
        var questions: [Int:Question]
        var answers: [Answer]
        
        for scenarioID in availableScenarioIDs {
            // Given
            do {
                questions = try DatabaseAccessor.sharedInstance.getQuestions(of: scenarioID)
            } catch _ {
                fatalError("Error fetching questions of scenario \(scenarioID)")
            }
            
            // Loop through the questions to get answers corresponding to the question.
            for (questionID, _) in questions {
                // When
                do {
                    answers = try DatabaseAccessor.sharedInstance.getAnswers(of: questionID)
                } catch _ {
                    fatalError("Error fetching answers of question \(questionID)")
                }
                
                // Then (Check that all answers transition to a valid question of the same scenario.)
                for answer in answers {
                    if let nextQuestion = Int(answer.nextQuestionID) {
                        // Can cast to integer.
                        
                        // Greater than zero, meaning transition to another question.
                        if nextQuestion > 0 {
                            // Next question should be valid (contains in the questions dictionary.)
                            XCTAssertNotNil(questions[nextQuestion])
                        }
                        
                        // (Less than zero, meaning transition to a mini game.)
                    }
                    
                    // (Cannot cast to int, meaning transition to result scene.)
                }
            }
        }
    }
}
