/** This struct is a data model for question/answer pair. */

struct Answer {
    // Each answer has a unique ID.
    var answerID: Int
    
    // The question corresponding to this answer.
    var questionID: Int
    
    // This consists of the actual answer text.
    var answerDescription: String
    
    // Stored the ID of next question which the game transisted to if this answer is chosen.
    var nextQuestionID: String
    
    // TODO: The team should decide whether "points" should be attached to each answer.
    var points: Int
    
    // ID determining if/which OOC event should occur
    var popupID: String
    
    init(answerID: Int, questionID: Int, answerDescription: String, nextQuestionID: String, points: Int, popupID: String) {
        self.answerID = answerID
        self.questionID = questionID
        self.answerDescription = answerDescription
        self.nextQuestionID = nextQuestionID
        self.points = points
        self.popupID = popupID
    }
}
