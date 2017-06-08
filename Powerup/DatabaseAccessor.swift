/** This is a singleton class for acessing SQLite Database. */

class DatabaseAccessor {
    
    // Database file name
    private let DatabaseName = "mainDatabase"
    private let DatabaseFileType = "sqlite"
    private let avatarID = 1
    
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
    
    /**
      Save the accessories, clothing, etc. in the database.
      
      - Parameter: Face, clothes, hair, eyes, necklace, glasses, handbag, hat.
      - Return: A Bool indicating whether the save is successful.
    */
    public func saveAvatar(faceIndex: Int, clothesIndex: Int, hairIndex: Int, eyesIndex: Int, necklaceIndex: Int?, glassesIndex: Int?, handbagIndex: Int?, hatIndex: Int?)  -> Bool{
        // Determine whether they are nil, if they are, set its string to "NULL"
        let necklaceString = necklaceIndex == nil ? "NULL" : String(necklaceIndex! + 1)
        let glassesString = glassesIndex == nil ? "NULL" : String(glassesIndex! + 1)
        let handbagString = handbagIndex == nil ? "NULL" : String(handbagIndex! + 1)
        let hatString = hatIndex == nil ? "NULL" : String(hatIndex! + 1)
        
        // Set the query string.
        let queryString = "UPDATE Avatar SET Face=\(faceIndex + 1), Clothes=\(clothesIndex + 1), Hair=\(hairIndex + 1), Eyes=\(eyesIndex + 1), Necklace=" + necklaceString + ", Glasses=" + glassesString + ", Handbag=" + handbagString + ", Hat=" + hatString + " WHERE ID = \(avatarID)"
        
        assert(mainDB != nil)
        
        // Execute update query.
        guard mainDB!.executeUpdate(queryString, withArgumentsIn: nil) else {
            print("Error updating database")
            return false
        }
        
        return true
    }
    
    /**
      Get the strings of accessories, clothing, etc. from the database.
    
      - Return: A dictionary of strings mapping accessorie name to (index, image string) tuple.
    */
    public func getAvatar() -> [String: (Int, String)] {
        let queryString = "SELECT * FROM Avatar WHERE ID = \(avatarID)"
        let queryResults: FMResultSet? = mainDB?.executeQuery(queryString, withArgumentsIn: nil)
        
        var result = [String: (Int,String)]()
        
        // Get the results.
        if queryResults?.next() == true {
            let queryTableNames = ["Face", "Clothes", "Hair", "Eyes", "Necklace", "Glasses", "Handbag", "Hat"]
            
            for name in queryTableNames {
                
                // Necklace, Glasses, Handbag, Hat might be nil.
                let accessoryID: Int? = (queryResults!.isNull(forColumn: name) ? nil : Int(queryResults!.int(forColumn: name)))
                
                // Skip if the avatar don't have the accessory.
                if accessoryID == nil {
                    continue
                }
                
                let accessoryQueryString = "SELECT Name FROM " + name + " WHERE ID=\(accessoryID!)"
                let accessoryQueryResults: FMResultSet? = mainDB?.executeQuery(accessoryQueryString, withArgumentsIn: nil)
                
                if accessoryQueryResults?.next() == true {
                    // Configure the result dictionary.
                    result[name] = ((accessoryID! - 1), accessoryQueryResults!.string(forColumn: "Name"))
                    
                } else {
                    print("Error fetching accessory " + name)
                }
        
            }
            
            
        } else {
            print("Error fetching avatar data.")
        }
        
        return result
    }
    
    /** 
      Get accessory names in an array.
      - Parameter: Accessory name.
      - Return: An array containing the names of accessories in an array.
    */
    public func getAccessoryArray(accessoryName: String) -> [String] {
        let queryString = "SELECT * FROM " + accessoryName + " ORDER BY ID"
        let queryResults: FMResultSet? = mainDB?.executeQuery(queryString, withArgumentsIn: nil)
        
        var result = [String]()
        
        while queryResults?.next() == true {
            result.append(queryResults!.string(forColumn: "Name"))
        }
        
        return result
    }

    /**
      Create a new entry into the Avatar table.
      - Parameter: Face, clothes, hair, eyes.
      - Return: Bool, indicating if creation is successful.
    */
    public func createAvatar(faceIndex: Int, clothesIndex: Int, hairIndex: Int, eyesIndex: Int) -> Bool {
        // Avatar already exists, use update instead of insert.
        if avatarExists() {
            guard saveAvatar(faceIndex: faceIndex, clothesIndex: clothesIndex, hairIndex: hairIndex, eyesIndex: eyesIndex, necklaceIndex: nil, glassesIndex: nil, handbagIndex: nil, hatIndex: nil) else {
                print("Error saving avatar.")
                return false
            }
            
            return true
        }
        
        let queryString = "INSERT INTO Avatar (ID, Face, Clothes, Hair, Eyes, Necklace, Glasses, Handbag, Hat) VALUES (\(avatarID), \(faceIndex + 1), \(clothesIndex + 1), \(hairIndex + 1), \(eyesIndex + 1), NULL, NULL, NULL, NULL)"
        
        assert(mainDB != nil)
        
        guard mainDB!.executeStatements(queryString) else {
            print("Error creating avatar.")
            return false
        }
        
        return true
    }
    
    /**
      Check if an avatar is already created.
      - Return: Bool, true if there exist an avatar.
    */
    public func avatarExists() -> Bool {
        let queryString = "SELECT * FROM Avatar WHERE ID = \(avatarID)"
        let queryResults: FMResultSet? = mainDB?.executeQuery(queryString, withArgumentsIn: nil)
        return queryResults?.next() ?? false
    }
    
    /** Close database if it's opened */
    public func closeDatabase () {
        mainDB?.close()
    }
}
