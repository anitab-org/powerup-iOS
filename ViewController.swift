

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var t1: UITextField!

    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var find: UIButton!
    
    @IBOutlet weak var test: UIButton!

    
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
                let question = "SELECT QDescription FROM Question Where QID=1"
                let Aoption = "SELECT ADescription FROM Answer WHERE QID=1 AND AID=1"
                let Boption = "SELECT ADescription FROM Answer WHERE QID=1 AND AID=2"
            
            let qresults:FMResultSet? = mainDB.executeQuery(question,
                withArgumentsInArray: nil)
            
            let aresults:FMResultSet? = mainDB.executeQuery(Aoption,
                withArgumentsInArray: nil)
            let bresults:FMResultSet? = mainDB.executeQuery(Boption,
                withArgumentsInArray: nil)
            
            
            if qresults?.next() == true {
                t1.text = qresults?.stringForColumn("QDescription")

                
            }
            
            if aresults?.next() == true {
            find.setTitle(aresults?.stringForColumn("ADescription"), forState: .Normal)
            }
            if bresults?.next() == true {
                test.setTitle(bresults?.stringForColumn("ADescription"), forState: .Normal)
                

            }
            
        
        }
        mainDB.close()
    }
    
    
    
    

    @IBAction func find(sender: UIButton) {
        
    }


    @IBAction func Boption(sender: UIButton) {
           }
    

}