/** This struct is a data model for each dialogue scenario's status. */

struct Scenario {
    var id: Int
    var name: String
    var timestamp: Int
    var asker: String
    var firstQuestionID: Int
    var unlocked: Bool
    var completed: Bool
    var nextScenarioID: Int
    
    init(id: Int = 0, name: String = "", timestamp: Int = 0, asker: String = "", firstQuestionID: Int = 0, unlocked: Bool = false, completed: Bool = false, nextScenarioID: Int = 0) {
        self.id = id
        self.name = name
        self.timestamp = timestamp
        self.asker = asker
        self.firstQuestionID = firstQuestionID
        self.unlocked = unlocked
        self.completed = completed
        self.nextScenarioID = nextScenarioID
    }
}
