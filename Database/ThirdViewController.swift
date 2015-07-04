
//  ThirdViewController.swift
//  Database

import UIKit

class ThirdViewController: UIViewController {
    
    
    @IBOutlet weak var S3Marcello: UITextField!
    
    @IBOutlet weak var S3Aoption: UIButton!
    
    @IBOutlet weak var S3Boption: UIButton!

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
        
        if mainDB.open(){
            let question = "SELECT QDescription FROM Question Where QID=2"
            let Aoption = "SELECT ADescription FROM Answer WHERE AID=4"
            let Boption = "SELECT ADescription FROM Answer WHERE AID=3"
            
            let qresults:FMResultSet? = mainDB.executeQuery(question,
                withArgumentsInArray: nil)
            
            let aresults:FMResultSet? = mainDB.executeQuery(Aoption,
                withArgumentsInArray: nil)
            let bresults:FMResultSet? = mainDB.executeQuery(Boption,
                withArgumentsInArray: nil)
            
            
            if qresults?.next() == true
            {
                S3Marcello.text = qresults?.stringForColumn("QDescription")
                }
            if aresults?.next() == true
            {
                S3Aoption.setTitle(aresults?.stringForColumn("ADescription"), forState: .Normal)
            }
            if bresults?.next() == true
            {
                S3Boption.setTitle(bresults?.stringForColumn("ADescription"), forState: .Normal)
                
        }
        }
         mainDB.close()
}

}
