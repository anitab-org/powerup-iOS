//
//  Choices-FirstScreen.swift
//  Database


import UIKit

class Choices_FirstScreen: UIViewController {
    
    @IBOutlet weak var Question: UITextView!
    
    @IBOutlet weak var AnswerView: UITextView!
    
    
    var databasePath = NSString()
    
    // Orientation - set to Portrait
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
       }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Back Button of navigation controller hidden
        self.navigationItem.setHidesBackButton(false, animated:true);
        
        Question.selectable = false
        Question.editable = false
        AnswerView.editable = false
        AnswerView.selectable = false
        
        
        Question!.layer.borderWidth = 6
        Question!.layer.borderColor = UIColor.blackColor().CGColor
        Question!.layer.cornerRadius = 5
        
        AnswerView!.layer.borderWidth = 6
        AnswerView!.layer.borderColor = UIColor.blackColor().CGColor
        AnswerView!.layer.cornerRadius = 5
        
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        
        // Accessing the Choices.sqlite database and getting its location
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] 
        var error:NSError?
        
        databasePath = (docsDir as NSString).stringByAppendingPathComponent("Choices.sqlite")
        
       if filemgr.fileExistsAtPath(databasePath as String){
            print("FOUND!!!!")
            do {
                try filemgr.removeItemAtPath(databasePath as String)
            } catch let error1 as NSError {
                error = error1
            }
            
        }

        if let bundle_path = NSBundle.mainBundle().pathForResource("Choices", ofType: "sqlite"){
        print("Test!!!!!!!!")
            
        do {
            try filemgr.copyItemAtPath(bundle_path, toPath: databasePath as String)
                print("Success!!!!!!!!")
        } catch let error1 as NSError {
            error = error1
                print("Failure")
            print(error?.localizedDescription)
            }
            }
        let mainDB = FMDatabase(path: databasePath as String)
        
        // Fetching required data from the database through suitable queries
        if mainDB.open(){
            print("DB is open and running...")
            
            
            let question1 = "SELECT Text FROM Communication WHERE QID= 'A' AND AID='$'"
            let answer1 =   "SELECT Text FROM Communication WHERE QID='A' AND AID='A1'"
            
            
            let qresults:FMResultSet? = mainDB.executeQuery(question1,
                withArgumentsInArray: nil)
            
            let aresults:FMResultSet? = mainDB.executeQuery(answer1,
                withArgumentsInArray: nil)
            
            if qresults?.next() == true {
                Question.text = qresults?.stringForColumn("Text")
                
            }
            
            if aresults?.next() == true {
                AnswerView.text = aresults?.stringForColumn("Text")
            }
            
        }
        mainDB.close()
    
}
    
    
    
    
    @IBAction func AnswerButton(sender: UIButton) {
    
    
    }
    
}











