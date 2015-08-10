
//  Choices-FourthScreen.swift
//  Database

import UIKit

class Choices_FourthScreen: UIViewController {

    
    @IBOutlet weak var Question: UITextView!
    
    @IBOutlet weak var AnswerView1: UITextField!
    
    @IBOutlet weak var AnswerView2: UITextView!
    
    @IBOutlet weak var AnswerView3: UITextField!
    
    var databasePath = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        
        databasePath = docsDir.stringByAppendingPathComponent(
            "Choices.sqlite")
        
        if filemgr.fileExistsAtPath(databasePath as String){
            println("FOUND!!!!")
            
        }
        
        
        let mainDB = FMDatabase(path: databasePath as String)
        if mainDB == nil{
            println("Error: \(mainDB.lastErrorMessage())")
        }
        
        
        if mainDB.open(){
            
            
            let question4 = "SELECT Text FROM ChoicesTable WHERE QID=4 AND RefID='$'"
            let answer4a =  "SELECT Text FROM ChoicesTable WHERE QID=4 AND RefID=1"
            let answer4b =  "SELECT Text FROM ChoicesTable WHERE QID=4 AND RefID=2"
            let answer4c =  "SELECT Text FROM ChoicesTable WHERE QID=4 AND RefID=3"
            
            
            let qresults:FMResultSet? = mainDB.executeQuery(question4,
                withArgumentsInArray: nil)
            
            let aresults:FMResultSet? = mainDB.executeQuery(answer4a,
                withArgumentsInArray: nil)
            let bresults:FMResultSet? = mainDB.executeQuery(answer4b,
                withArgumentsInArray: nil)
            let cresults:FMResultSet? = mainDB.executeQuery(answer4c,
                withArgumentsInArray: nil)
            
            
            if qresults?.next() == true {
                Question.text = qresults?.stringForColumn("Text")
            }
            
            if aresults?.next() == true {
                AnswerView1.text = aresults?.stringForColumn("Text")
            }
            if bresults?.next() == true {
                AnswerView2.text = bresults?.stringForColumn("Text")
            }
            if cresults?.next() == true {
                AnswerView3.text = cresults?.stringForColumn("Text")
            }
            
        }
        
        
        
        
        
        
        mainDB.close()
        
        
    }

    @IBAction func Answer1Button(sender: UIButton) {
    }
   
    @IBAction func Answer2Button(sender: UIButton) {
    }
    
    
    @IBAction func Answer3Button(sender: UIButton) {
    }
    


}
