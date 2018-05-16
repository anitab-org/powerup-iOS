import XCTest

@testable import Powerup

class ScenarioViewControllerTests: XCTestCase {
    
    var scenarioViewController: ScenarioViewController!
    
    // Mock data source.
    class MockSource: DataSource {
        
        // Question ID -> Answers
        var answers: [Int:[Answer]]
        var questions: [Int:Question]
        
        init(answers: [Answer], questions: [Question]) {
            self.answers = [Int:[Answer]]()
            for answer in answers {
                let questionID = answer.questionID
                
                if self.answers[questionID] == nil {
                    self.answers[questionID] = [Answer]()
                }
                
                self.answers[questionID]!.append(answer)
            }
            
            
            self.questions = [Int:Question]()
            for question in questions {
                self.questions[question.questionID] = question
            }
        }
        
        override func getAnswers(of questionID: Int) -> [Answer] {
            return answers[questionID] ?? [Answer]()
        }
        
        override func getQuestions(of scenarioID: Int) -> [Int:Question] {
            return questions
        }
    }
    
    override func setUp() {
        scenarioViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Scenario View Controller") as! ScenarioViewController
            scenarioViewController.loadView()
        
        super.setUp()
    }
    
    override func tearDown() {
        scenarioViewController = nil
        
        super.tearDown()
    }
    
    /**
      - Test that the transition of questions to questions by choices selection is correct.
    */
    func testAnswerSelection() {
        // Given
        let questions = [
            Question(questionID: 1, questionDescription: "Question 1", scenarioID: 1),
            Question(questionID: 2, questionDescription: "Question 2", scenarioID: 1),
            Question(questionID: 3, questionDescription: "Question 3", scenarioID: 1),
            Question(questionID: 4, questionDescription: "Question 4", scenarioID: 1)
        ]
        
        let answers = [
            Answer(answerID: 1, questionID: 1, answerDescription: "Q1 A1 to Q2", nextQuestionID: "2", points: 0, popupID: "#"),
            Answer(answerID: 2, questionID: 2, answerDescription: "Q2 A2 to Q4", nextQuestionID: "4", points: 0, popupID: "1"),
            Answer(answerID: 3, questionID: 4, answerDescription: "Q4 A3 to Q1", nextQuestionID: "1", points: 0, popupID: "-1")
        ]
        
        let mockData = MockSource(answers: answers, questions: questions)
        
        scenarioViewController.dataSource = mockData
        scenarioViewController.scenarioID = 1
        scenarioViewController.currQuestionID = 1
        scenarioViewController.initializeQuestions()
        scenarioViewController.resetQuestionAndChoices()
        
        let choiceTable = scenarioViewController.choicesTableView!
        let questionLabel = scenarioViewController.questionLabel
        
        // When
        // Cell (choice) selected in the first question.
        scenarioViewController.tableView(choiceTable, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        // Then
        // Question description is correct.
        XCTAssertEqual(questionLabel!.text, questions[1].questionDescription)
        
        // When
        for _ in 0..<2 {
            scenarioViewController.tableView(choiceTable, didSelectRowAt: IndexPath(row: 0, section: 0))
        }
        
        // Then
        XCTAssertEqual(questionLabel!.text, questions[0].questionDescription)
    }
}
