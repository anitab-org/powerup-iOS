

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var mar_text: UITextView!

    @IBOutlet weak var answerViewA: UITextField!
    @IBOutlet weak var answerViewB: UITextField!
    @IBOutlet weak var label: UILabel!

    
    
    var databasePath = NSString()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        mar_text.editable = false
        mar_text.selectable = false
        
        
        mar_text!.layer.borderWidth = 6
        mar_text!.layer.borderColor = UIColor.blackColor().CGColor
        mar_text!.layer.cornerRadius = 5
        
        answerViewA!.layer.borderWidth = 6
        answerViewA!.layer.borderColor = UIColor.blackColor().CGColor
        answerViewA!.layer.cornerRadius = 5
        
        answerViewB!.layer.borderWidth = 6
        answerViewB!.layer.borderColor = UIColor.blackColor().CGColor
        answerViewB!.layer.cornerRadius = 5
        
        bgImage.image = UIImage(named: "endingscreen")
        
        
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        var error: NSError?
        
        databasePath = docsDir.stringByAppendingPathComponent(
            "mainDatabase.sqlite")
        
        
        
        
        if filemgr.fileExistsAtPath(databasePath as String){
            println("FOUND!!!!")
            filemgr.removeItemAtPath(databasePath as String, error: &error)
            
        }
        
        if let bundle_path = NSBundle.mainBundle().pathForResource("mainDatabase", ofType: "sqlite"){
            println("Test!!!!!!!!")
            
            if filemgr.copyItemAtPath(bundle_path, toPath: databasePath as String, error: &error){
                println("Success!!!!!!!!")
            }
            else{
                println("Failure")
                println(error?.localizedDescription)
            }
        }

        
        
        
        let mainDB = FMDatabase(path: databasePath as String)
            if mainDB == nil{
                println("Error: \(mainDB.lastErrorMessage())")
            }
        
            
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
                mar_text.text = qresults?.stringForColumn("QDescription")

                
            }
            
            if aresults?.next() == true {
        answerViewA.text = aresults?.stringForColumn("ADescription")
                }
            if bresults?.next() == true {
                answerViewB.text = bresults?.stringForColumn("ADescription")
                
                

            }
            
        
        }
        mainDB.close()
    }
    
    
    
    
    

    @IBAction func find(sender: UIButton) {
        
    }


    @IBAction func Boption(sender: UIButton) {
           }
    

}