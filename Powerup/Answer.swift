/** This struct is a data model for question/answer pair. */

struct Answer {
    var answerID: Int
    var questionID: Int
    var answerDescription: String
    var nextQuestionID: String
    var points: Int
    
    init(answerID: Int, questionID: Int, answerDescription: String, nextQuestionID: String, points: Int) {
        self.answerID = answerID
        self.questionID = questionID
        self.answerDescription = answerDescription
        self.nextQuestionID = nextQuestionID
        self.points = points
    }
}
