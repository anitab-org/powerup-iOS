/** This struct is a data model for each question and the scenario it belongs to. */

struct Question {
    var questionID: Int
    var questionDescription: String
    var scenarioID: Int
    
    init(questionID: Int, questionDescription: String, scenarioID: Int) {
        self.questionID = questionID
        self.questionDescription = questionDescription
        self.scenarioID = scenarioID
    }
}
