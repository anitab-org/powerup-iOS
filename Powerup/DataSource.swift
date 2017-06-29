/** Every data provider class should implement this protocol. */
protocol DataSource {
    func initializeDatabase() throws
    func getQuestions(of scenarioID: Int) throws -> [Int:Question]
    func getAnswers(of questionID: Int) throws -> [Answer]
    func saveAvatar(_ avatar: Avatar) throws
    func getAvatar() throws -> Avatar
    func getAccessoryArray(accessoryType: AccessoryType) -> [Accessory]
    func getAccessory(accessoryType: AccessoryType, accessoryIndex: Int) throws -> Accessory
    func boughtAccessory(accessory: Accessory) throws
    func createAvatar(_ avatar: Avatar) throws
    func avatarExists() -> Bool
    func saveScore(score: Score) throws
    func getScore() throws -> Score
    func databaseIsInitialized() -> Bool
    func resetDatabase() throws
}
