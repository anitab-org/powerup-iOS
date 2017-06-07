/** This struct is a data model for each dialogue scenario's status. */

struct Scenario {
    var id: Int
    var scenarioName: String
    var timestamp: String
    var asker: String
    var avatar: Int
    var firstQuestionID: Int
    var completed: Bool
    var nextScenarioID: Int
    var replayed: Int
}
