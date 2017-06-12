/** This is a singleton class for acessing SQLite Database. */

class DatabaseAccessor {
    
    // Database file name
    private let DatabaseName = "mainDatabase"
    private let DatabaseFileType = "sqlite"
    
    // TODO: Multiple avatars with different IDs.
    let avatarID = 1
    
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
            // TODO: Should handle this error.
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
            // TODO: Should handle this error.
            print("Error fetching questions from database.")
        }
        
        return result
    }
    
    /**
      Get the answers (choices) of a question from the database.
 
      - Parameter: The QuestionID.
      - Return: An array of answers, sorted by their answerID.
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
                // TODO: Should handle this error.
                print("Error fetching query results for answers.")
            }
        }
        
        return result
    }
    
    /**
      Save the accessories of the avatar in the database.
      
      - Parameter: An avatar class.
      - Return: A Bool indicating whether the save is successful.
    */
    public func saveAvatar(_ avatar: Avatar) -> Bool{
        // Determine whether they are nil, if they are, set its string to "NULL"
        let necklaceString = avatar.necklace == nil ? "NULL" : String(avatar.necklace!.id)
        let glassesString = avatar.glasses == nil ? "NULL" : String(avatar.glasses!.id)
        let handbagString = avatar.handbag == nil ? "NULL" : String(avatar.handbag!.id)
        let hatString = avatar.hat == nil ? "NULL" : String(avatar.hat!.id)
        
        // Set the query string.
        let queryString = "UPDATE Avatar SET Face=\(avatar.face.id), Clothes=\(avatar.clothes.id), Hair=\(avatar.hair.id), Eyes=\(avatar.eyes.id), Necklace=" + necklaceString + ", Glasses=" + glassesString + ", Handbag=" + handbagString + ", Hat=" + hatString + " WHERE ID = \(avatarID)"
        
        assert(mainDB != nil)
        
        // Execute update query.
        guard mainDB!.executeUpdate(queryString, withArgumentsIn: nil) else {
            print("Error updating database")
            return false
        }
        
        return true
    }
    
    /**
      Get the saved avatar from the database.
    
      - Return: A saved avatar stored in database.
    */
    public func getAvatar() -> Avatar {
        let queryString = "SELECT * FROM Avatar WHERE ID = \(avatarID)"
        let queryResults: FMResultSet? = mainDB?.executeQuery(queryString, withArgumentsIn: nil)
        
        var result = Avatar()
        
        // Get the results.
        if queryResults?.next() == true {
            
            // Face
            let faceID = Int(queryResults!.int(forColumn: "Face"))
            let face = getAccessory(accessoryType: "Face", accessoryIndex: faceID)
            
            // Clothes
            let clothesID = Int(queryResults!.int(forColumn: "Clothes"))
            let clothes = getAccessory(accessoryType: "Clothes", accessoryIndex: clothesID)
            
            // Hair
            let hairID = Int(queryResults!.int(forColumn: "Hair"))
            let hair = getAccessory(accessoryType: "Hair", accessoryIndex: hairID)
            
            // Eyes
            let eyesID = Int(queryResults!.int(forColumn: "Eyes"))
            let eyes = getAccessory(accessoryType: "Eyes", accessoryIndex: eyesID)
            
            // Necklace (optional)
            let necklaceID: Int? = (queryResults!.isNull(forColumn: "Necklace") ? nil : Int(queryResults!.int(forColumn: "Necklace")))
            let necklace: Accessory? = necklaceID == nil ? nil : getAccessory(accessoryType: "Necklace", accessoryIndex: necklaceID!)
            
            // Glasses (optional)
            let glassesID: Int? = (queryResults!.isNull(forColumn: "Glasses") ? nil : Int(queryResults!.int(forColumn: "Glasses")))
            let glasses: Accessory? = glassesID == nil ? nil : getAccessory(accessoryType: "Glasses", accessoryIndex: glassesID!)
            
            // Handbag (optional)
            let handbagID: Int? = (queryResults!.isNull(forColumn: "Handbag") ? nil : Int(queryResults!.int(forColumn: "Handbag")))
            let handbag: Accessory? = handbagID == nil ? nil : getAccessory(accessoryType: "Handbag", accessoryIndex: handbagID!)
            
            // Hat (optional)
            let hatID: Int? = (queryResults!.isNull(forColumn: "Hat") ? nil : Int(queryResults!.int(forColumn: "Hat")))
            let hat: Accessory? = hatID == nil ? nil : getAccessory(accessoryType: "Hat", accessoryIndex: hatID!)
            
            // Init avatar
            result = Avatar(avatarID: avatarID, face: face, eyes: eyes, hair: hair, clothes: clothes, necklace: necklace, glasses: glasses, handbag: handbag, hat: hat)
            
        } else {
            // TODO: Should handle this error.
            print("Error fetching avatar data.")
        }
        
        return result
    }
    
    /** 
      Get an array of accessories of a type.
      - Parameter: Accessory type (i.e. Hair, Face, etc.).
      - Return: An array of accessories.
    */
    public func getAccessoryArray(accessoryType: String) -> [Accessory] {
        let queryString = "SELECT * FROM " + accessoryType + " ORDER BY ID"
        let queryResults: FMResultSet? = mainDB?.executeQuery(queryString, withArgumentsIn: nil)
        
        var result = [Accessory]()
        
        while queryResults?.next() == true {
            let accessoryID = Int(queryResults!.int(forColumn: "ID"))
            let accessoryImageName = queryResults!.string(forColumn: "Name")
            let accessoryPoints = Int(queryResults!.int(forColumn: "Points"))
            let accessoryPurchased = queryResults!.bool(forColumn: "Purchased")
            
            let currAccessory = Accessory(type: accessoryType, id: accessoryID, imageName: accessoryImageName!, points: accessoryPoints, purchased: accessoryPurchased)
            
            result.append(currAccessory)
        }
        
        return result
    }
    
    /**
      Get an accessory by a given accessory type and index.
      - Parameter: index.
      - Return: The corresponding accessories.
    */
    public func getAccessory(accessoryType: String, accessoryIndex: Int) -> Accessory {
        let queryString = "SELECT * FROM " + accessoryType + " WHERE ID = \(accessoryIndex)"
        let queryResults: FMResultSet? = mainDB?.executeQuery(queryString, withArgumentsIn: nil)
        
        var result: Accessory!
        
        if queryResults?.next() == true {
            let accessoryID = Int(queryResults!.int(forColumn: "ID"))
            let accessoryImageName = queryResults!.string(forColumn: "Name")
            let accessoryPoints = Int(queryResults!.int(forColumn: "Points"))
            let accessoryPurchased = queryResults!.bool(forColumn: "Purchased")
            
            result = Accessory(type: accessoryType, id: accessoryID, imageName: accessoryImageName!, points: accessoryPoints, purchased: accessoryPurchased)
        } else {
            // TODO: Should handle this error.
            print("Error fetching accessory from table " + accessoryType + ".")
        }
        
        return result
    }

    /**
      Create a new entry into the Avatar table.
      - Parameter: Face, clothes, hair, eyes.
      - Return: Bool, indicating whether the creation is successful.
    */
    public func createAvatar(_ avatar: Avatar) -> Bool {
        // Avatar already exists, use update instead of insert.
        if avatarExists() {
            guard saveAvatar(avatar) else {
                print("Error saving avatar.")
                return false
            }
            
            return true
        }
        
        // Necklace, glasses, handbag, hat are NULL because players cannot have those when creating new avatars.
        let queryString = "INSERT INTO Avatar (ID, Face, Clothes, Hair, Eyes, Necklace, Glasses, Handbag, Hat) VALUES (\(avatarID), \(avatar.face.id), \(avatar.clothes.id), \(avatar.hair.id), \(avatar.eyes.id), NULL, NULL, NULL, NULL)"
        
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
