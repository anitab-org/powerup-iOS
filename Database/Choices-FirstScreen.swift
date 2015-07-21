//
//  Choices-FirstScreen.swift
//  Database


import UIKit

class Choices_FirstScreen: UIViewController {
    
    @IBOutlet weak var Question: UITextView!
    
    @IBOutlet weak var AnswerView: UITextView!
    

    
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
        
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        
        if mainDB.open(){
            let question1 = "SELECT Text FROM ChoicesTable WHERE QID=1 AND RefID='$'"
            let answer1 =   "SELECT Text FROM ChoicesTable WHERE QID=1 AND RefID=1"
            
            
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











