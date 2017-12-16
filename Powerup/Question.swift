/** This struct is a data model for each question and the scenario it belongs to. */

struct Question {
    // Each question has a unique ID.
    var questionID: Int
    
    // The actual text of the question.
    var questionDescription: String
    
    // The scenario where the question is in.
    var scenarioID: Int
    
    init(questionID: Int, questionDescription: String, scenarioID: Int) {
        self.questionID = questionID
        self.questionDescription = questionDescription
        self.scenarioID = scenarioID
    }
}
