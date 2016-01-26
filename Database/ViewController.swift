// Screen 1 for Sex- Scenario

import UIKit

class ViewController: UIViewController {

    let defaults = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var mar_text: UITextView!

    @IBOutlet weak var answerViewA: UITextField!
    @IBOutlet weak var answerViewB: UITextField!
    @IBOutlet weak var label: UILabel!
    
    
    @IBOutlet weak var health: UIImageView!

    
    @IBOutlet weak var currentemotion: UILabel!
    
    var databasePath = NSString()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(defaults.integerForKey("health") == 0){
            defaults.setInteger(100, forKey: "health")
        }
        // Hide back button of navigation controller
        self.navigationItem.setHidesBackButton(false, animated:true);
        
        // Making textview non editable and non-selectable so that user can't change the content
        
        if(defaults.integerForKey("health") > 50){
            currentemotion.text = "Happy"
            health.image = UIImage(named:"green-1")
        }
        let length = defaults.integerForKey("health") 
        health = UIImageView(frame: CGRect(x: length, y: 27, width: 201, height: 535));
        
        mar_text.editable = false
        mar_text.selectable = false
        
        
        // Borders and rounded corners for textfields and textviews
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
        
        
        // Fetching database content via FMDB wrapper
        
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
        
        // opening the database and extracting content through suitable queries
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
    
    
    
    
    // clickable Option A button

    @IBAction func find(sender: UIButton) {
        
    }

 // clickable Option B button
    @IBAction func Boption(sender: UIButton) {
           }
    

}