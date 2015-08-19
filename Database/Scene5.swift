//
//  Scene5.swift
//  Database


import UIKit

class Scene5: UIViewController {
    
    @IBOutlet weak var mar_text: UITextView!
    
    @IBOutlet weak var answerViewA: UITextView!
    
    @IBOutlet weak var answerViewB: UITextView!
    
    @IBOutlet weak var answerViewC: UITextView!
    
    var databasePath = NSString()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        mar_text.editable = false
        mar_text.selectable = false
        
        answerViewA.editable = false
        answerViewA.selectable = false
        
        answerViewB.editable = false
        answerViewB.selectable = false
        
        answerViewC.editable = false
        answerViewC.selectable = false
        
        mar_text!.layer.borderWidth = 6
        mar_text!.layer.borderColor = UIColor.blackColor().CGColor
        mar_text!.layer.cornerRadius = 5
        
        answerViewA!.layer.borderWidth = 6
        answerViewA!.layer.borderColor = UIColor.blackColor().CGColor
        answerViewA!.layer.cornerRadius = 5
        
        answerViewB!.layer.borderWidth = 6
        answerViewB!.layer.borderColor = UIColor.blackColor().CGColor
        answerViewB!.layer.cornerRadius = 5
        
        answerViewC!.layer.borderWidth = 6
        answerViewC!.layer.borderColor = UIColor.blackColor().CGColor
        answerViewC!.layer.cornerRadius = 5

        
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        
        databasePath = docsDir.stringByAppendingPathComponent(
            "mainDatabase.sqlite")
        
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if mainDB.open(){
            let question = "SELECT QDescription FROM Question Where QID=5"
            let Aoption = "SELECT ADescription FROM Answer WHERE AID=8"
            let Boption = "SELECT ADescription FROM Answer WHERE AID=9"
            let Coption = "SELECT ADescription FROM Answer WHERE AID=10"
            
            
            let qresults:FMResultSet? = mainDB.executeQuery(question,
                withArgumentsInArray: nil)
            
            let aresults:FMResultSet? = mainDB.executeQuery(Aoption,
                withArgumentsInArray: nil)
            let bresults:FMResultSet? = mainDB.executeQuery(Boption,
                withArgumentsInArray: nil)
            let cresults:FMResultSet? = mainDB.executeQuery(Coption,
                withArgumentsInArray: nil)
            
            
            if qresults?.next() == true
            {
                mar_text.text = qresults?.stringForColumn("QDescription")
            }
            if aresults?.next() == true
            {
                answerViewA.text = aresults?.stringForColumn("ADescription")
                
                
            }
            if bresults?.next() == true
            {
                answerViewB.text = bresults?.stringForColumn("ADescription")
                
            }
            if cresults?.next() == true
            {
                answerViewC.text = cresults?.stringForColumn("ADescription")
                
            }
        
        }
        mainDB.close()
    }
    
    
    @IBAction func ansButton3(sender: UIButton) {
        
        var alertView = UIAlertView();
        alertView.addButtonWithTitle("Ok");
        alertView.title = "MESSAGE!!!";
        alertView.message = "SEX MINI - GAME!!!";
        
        alertView.show();
        

    }
    
}
