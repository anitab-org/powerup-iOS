//
//  SecondViewController.swift
//  Database


import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var S2Marcello: UITextField!
    
    @IBOutlet weak var S2Rosie: UITextField!
  

    var databasePath = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        
        databasePath = docsDir.stringByAppendingPathComponent(
            "mainDatabase.sqlite")
        
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
