/** This is a singleton class for acessing SQLite Database. */

class DatabaseAccessor {
    
    // Database file name
    private let DatabaseName = "mainDatabase"
    private let DatabaseFileType = "sqlite"
    
    // The instance of DatabaseAccessor
    private static var instance: DatabaseAccessor?
    
    // The instance of the SQLite database
    private var mainDB: FMDatabase?
    
    /** Access the instance throught this method. */
    public static func sharedInstance() -> DatabaseAccessor {
        
        // Database & instance not initialized yet
        if instance == nil {
            instance = DatabaseAccessor()
        }
        
        return instance!
    }
    
    // Private initializer to avoid instancing by other classes
    private init() {
        
        // Opening database
        let fileManager = FileManager.default
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let docsDir = dirPaths[0]
        let databasePath = (docsDir as NSString).appendingPathComponent(DatabaseName + "." + DatabaseFileType) as NSString
        
        if fileManager.fileExists(atPath: databasePath as String) {
            do {
                try fileManager.removeItem(atPath: databasePath as String)
            } catch let error as NSError {
                print(error)
            }
        }
        
        if let bundlePath = Bundle.main.path(forResource: DatabaseName, ofType: DatabaseFileType) {
            do {
                try fileManager.copyItem(atPath: bundlePath, toPath: databasePath as String)
            } catch let error as NSError {
                print(error)
            }
        }
        
        mainDB = FMDatabase(path: databasePath as String)
        
        if mainDB == nil || !((mainDB?.open())!) {
            print("Error opening database.")
        }
        
        
    }
    
    /**
      Get the questions of a scenario from the database.
      
      - Parameter: The scenario ID.
      - Return: A dictionary of [QuestionID -> Question].
    */
    public func getQuestions(of scenarioID: Int) -> [Int:Question] {
        let queryString = "SELECT * FROM Question WHERE ScenarioID = \(scenarioID)"
        let queryResults: FMResultSet? = mainDB?.executeQuery(queryString, withArgumentsIn: nil)
        
        var result = [Int:Question]()
        
        // Loop through all the results of questions
        while queryResults?.next() == true {
            if let questionID = queryResults?.int(forColumn: "QuestionID"), let scenarioID = queryResults?.int(forColumn: "ScenarioID"), let questionDescription = queryResults?.string(forColumn: "QDescription") {
                
                result[Int(questionID)] = Question(questionID: Int(questionID), questionDescription: questionDescription, scenarioID: Int(scenarioID))
            } else {
                print("Error fetching query results for questions.")
            }
        }
        
        if result.count == 0 {
            print("Error fetching questions from database.")
        }
        
        return result
    }
    
    /**
      Get the answers (choices) of a question from the database.
 
      - Parameter: The QuestionID.
      - Return: An array of answers, sorted by their answerID. If failed, return nil
    */
    public func getAnswers(of questionID: Int) -> [Answer] {
        let queryString = "SELECT * FROM Answer WHERE QuestionID = \(questionID) ORDER BY AnswerID"
        let queryResults: FMResultSet? = mainDB?.executeQuery(queryString, withArgumentsIn: nil)
        
        var result = [Answer]()
        
        // Loop through all the results of choices
        while queryResults?.next() == true {
            if let answerID = queryResults?.int(forColumn: "AnswerID"), let questionID = queryResults?.int(forColumn: "QuestionID"), let answerDescription = queryResults?.string(forColumn: "ADescription"), let nextQuestionID = queryResults?.string(forColumn: "NextQID"), let points = queryResults?.int(forColumn: "Points") {
                
                result.append(Answer(answerID: Int(answerID), questionID: Int(questionID), answerDescription: answerDescription, nextQuestionID: nextQuestionID, points: Int(points)))
                
            } else {
                print("Error fetching query results for answers.")
            }
        }
        
        return result
    }
    
    /** Close database if it's opened */
    public func closeDatabase () {
        mainDB?.close()
    }
}
