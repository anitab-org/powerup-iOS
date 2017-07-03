/** Every data provider class should inherit this class. (Easy for unit tests to mock data. */
class DataSource {
    func initializeDatabase() throws {}
    func getQuestions(of scenarioID: Int) throws -> [Int:Question] { return [Int:Question]() }
    func getAnswers(of questionID: Int) throws -> [Answer] { return [Answer]() }
    func saveAvatar(_ avatar: Avatar) throws {}
    func getAvatar() throws -> Avatar { return Avatar() }
    func getAccessoryArray(accessoryType: AccessoryType) -> [Accessory] { return [Accessory]() }
    func getAccessory(accessoryType: AccessoryType, accessoryIndex: Int) throws -> Accessory { return Accessory(type: .unknown) }
    func boughtAccessory(accessory: Accessory) throws {}
    func createAvatar(_ avatar: Avatar) throws {}
    func avatarExists() -> Bool { return false }
    func saveScore(score: Score) throws {}
    func getScore() throws -> Score { return Score() }
    func databaseIsInitialized() -> Bool { return false }
    func closeDatabase() {}
    func resetDatabase() throws {}
}
