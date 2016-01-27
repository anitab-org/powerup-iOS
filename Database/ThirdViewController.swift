
//  ThirdViewController.swift
//  Database

import UIKit

class ThirdViewController: UIViewController {
    
    
    @IBOutlet weak var mar_text: UITextView!

    @IBOutlet weak var answerViewA: UITextField!
    @IBOutlet weak var answerViewB: UITextView!
    
    @IBOutlet weak var thoughtbubble: UIImageView!

    var databasePath = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var imagesListArray :NSMutableArray = []
        // Back Button of navigation controller hidden
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        
        for position in 1...4
        {
            
            var strImageName : String = "thought\(position).png"
            var image  = UIImage(named:strImageName)
            imagesListArray.addObject(image!)
        }
        
        self.thoughtbubble.animationImages = imagesListArray as [AnyObject];
        self.thoughtbubble.animationDuration = 1.2
        self.thoughtbubble.startAnimating()
        // Making textviews non editable and non-selectable so that user can't change the content
        mar_text.editable = false
        mar_text.selectable = false
        
        answerViewB.editable = false
        answerViewB.selectable = false
        
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

        
        // Fetching database content via FMDB wrapper
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
        }
         mainDB.close()
}

}
