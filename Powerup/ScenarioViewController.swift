import UIKit

class ScenarioViewController: UIViewController {
    
    // current scenario, set by the MapViewController
    var scenarioID: Int = 0
    var questionID: Int = 1
    
    // the next question ID for each choices (if not an integer, the next scenario links to a mini game)
    var nextQuestionIDs = [String]()
    
    var eyeImage: UIImage!
    var faceImage: UIImage!
    var clothesImage: UIImage!
    var hairImage: UIImage!
    
    var databasePath = NSString()
    
    //MARK: Views
    @IBOutlet weak var bgImage: UIImageView!
    
    // Question Label and Choice Buttons
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var choiceButtons: Array<UIButton>!
    
    // ImageViews for avatar
    // These should be merged into a customized controller soon
    @IBOutlet weak var eyesview: UIImageView!
    @IBOutlet weak var hairview: UIImageView!
    @IBOutlet weak var faceview: UIImageView!
    @IBOutlet weak var clothesview: UIImageView!
    
    func resetQuestionAndChoices() {
        // Hide all the Buttons for choices, will show them only if the query to Database is successful
        for choiceButton in choiceButtons {
            choiceButton.isHidden = true
        }
        
        // Clear the array storing the next senario IDs
        nextQuestionIDs.removeAll()
        
        
        // Fetching database content via FMDB wrapper
        // This section should be replaced by accessing the database singleton
        let filemgr = FileManager.default
        let dirPaths =
            NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                .userDomainMask, true)
        
        let docsDir = dirPaths[0]
        databasePath = (docsDir as NSString).appendingPathComponent(
            "mainDatabase.sqlite") as NSString
        
        
        if filemgr.fileExists(atPath: databasePath as String){
            do {
                try filemgr.removeItem(atPath: databasePath as String)
            } catch let error as NSError {
                print(error)
            }
            
        }
        
        if let bundle_path = Bundle.main.path(forResource: "mainDatabase", ofType: "sqlite") {
            
            do {
                try filemgr.copyItem(atPath: bundle_path, toPath: databasePath as String)
            } catch let error as NSError {
                print(error)
            }
        }
        
        
        let mainDB = FMDatabase(path: databasePath as String)
        if mainDB == nil{
            print("Error opening database")
        }
        
        if (mainDB?.open())!{
            // Query the question text
            let questionQuery = "SELECT QDescription FROM Question WHERE ScenarioID = \(scenarioID) AND QID = \(questionID)"
            let questionQueryResults: FMResultSet? = mainDB?.executeQuery(questionQuery, withArgumentsIn: nil)
            
            // Set the question text
            if questionQueryResults?.next() == true {
                if let result = questionQueryResults?.string(forColumn: "QDescription") {
                    questionLabel.text = result
                } else {
                    print("Error querying QDescription!")
                }
            }
            
            // Query the texts for choices
            var choiceIndex = 0
            let choiceQuery = "SELECT * FROM Answer WHERE ScenarioID = \(scenarioID) AND QID = \(questionID) ORDER BY AID"
            let choiceResults: FMResultSet? = mainDB?.executeQuery(choiceQuery, withArgumentsIn: nil)
            
            // Loop through all the results of choices
            while choiceResults?.next() == true {
                // Configure the text for the Label
                if let result = choiceResults?.string(forColumn: "ADescription") {
                    choiceButtons[choiceIndex].setTitle(result, for: .normal)
                } else {
                    print("Error querying ADescription!")
                }
                
                
                // Record the next scenario ID for this choice
                if let result = choiceResults?.string(forColumn: "NextQID") {
                    nextQuestionIDs.append(result)
                } else {
                    print("Error querying NextQID!")
                }
                
                
                // Show the Button
                choiceButtons[choiceIndex].isHidden = false
                
                choiceIndex += 1
            }
            
        }
        mainDB?.close()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eyesview.image = eyeImage
        hairview.image = hairImage
        faceview.image = faceImage
        clothesview.image = clothesImage
        
        resetQuestionAndChoices()
        
        bgImage.image = UIImage(named: "endingscreen")

    }
    
    // MARK: Actions
    @IBAction func choiceSelected(_ sender: UIButton) {
        // Check which button is selected
        var selectedIndex = 0
        while sender != choiceButtons[selectedIndex] {
            selectedIndex += 1
        }
        
        // Check if the next questionID is a valid integer, if not, it's the end of the scnario (entering a mini game)
        if let nextQuestionID = Int(nextQuestionIDs[selectedIndex]) {
            // Set the new question ID and reset the questions & choices
            questionID = nextQuestionID
            resetQuestionAndChoices()
        } else {
            // Perform modal segue to mini game scene
            performSegue(withIdentifier: "toMiniGame", sender: self)
        }
        
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // prepare for MiniGameViewController
    }
    

}
