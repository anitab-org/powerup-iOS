//
//  SecondViewController.swift
//  Database


import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var S2Marcello: UITextField!
    
    @IBOutlet weak var S2Rosie: UITextField!
    
    @IBOutlet weak var continueToEnd: UIButton!
  
    var counter = 0
    
    var databasePath = NSString()
    var points = 0
    var passString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Back Button of navigation controller hidden
        self.navigationItem.setHidesBackButton(true, animated:true);

        S2Marcello!.layer.borderWidth = 6
        S2Marcello!.layer.borderColor = UIColor.blackColor().CGColor
        S2Marcello!.layer.cornerRadius = 5
        
        S2Rosie!.layer.borderWidth = 6
        S2Rosie!.layer.borderColor = UIColor.blackColor().CGColor
        S2Rosie!.layer.cornerRadius = 5
        
        
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as! NSString).stringByAppendingPathComponent(
            "Contraceptives.sqlite")
        
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if mainDB.open() {
            let question = "SELECT QDescription FROM Question Where QID=3"
            let answer = "SELECT ADescription FROM Answer WHERE AID=15"
            
            let qresults:FMResultSet? = mainDB.executeQuery(question,
                withArgumentsInArray: nil)
            
            let aresults:FMResultSet? = mainDB.executeQuery(answer,
                withArgumentsInArray: nil)
            
            if qresults?.next() == true {
                S2Marcello.text = qresults?.stringForColumn("QDescription")
            }
            
            if aresults?.next() == true{
                S2Rosie.text = aresults?.stringForColumn("ADescription")
                
            }
        }
        mainDB.close()
    
        
        
    }

    @IBAction func continueButton(sender: UIButton) {
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "done"
        {
            if let destinationVC = segue.destinationViewController as? Scene_EndScreen{
                destinationVC.sampleText = passString
                print("\(passString)")
                destinationVC.numberToDisplay = points
            }
        }
        
    }

}
