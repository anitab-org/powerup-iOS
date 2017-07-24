/* Question and correct answer of the sink to swim mini game. */
struct SinkToSwimQuestion {
    var description: String
    var correctAnswer: Bool
    
    init(description: String, correctAnswer: Bool) {
        self.description = description
        self.correctAnswer = correctAnswer
    }
}
