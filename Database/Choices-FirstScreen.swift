//
//  Choices-FirstScreen.swift
//  Database


import UIKit

class Choices_FirstScreen: UIViewController {
    
    @IBOutlet weak var marco: UIImageView!
    @IBOutlet weak var girl: UIImageView!
    @IBOutlet weak var Question: UITextView!
    
    @IBOutlet weak var AnswerView: UITextView!
    

    var databasePath = NSString()
    
    // Orientation - set to Portrait
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
       }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var shrink = false
        // Back Button of navigation controller hidden
        self.navigationItem.setHidesBackButton(false, animated:true);
        
        ////
        var hover: CABasicAnimation = CABasicAnimation(keyPath: "position")
        hover.additive = true
        // fromValue and toValue will be relative instead of absolute values
        hover.fromValue = NSValue(CGPoint: CGPointZero)
        hover.toValue = NSValue(CGPoint: CGPointMake(0.0, -10.0))
        // y increases downwards on iOS
        hover.autoreverses = true
        // Animate back to normal afterwards
        hover.duration = 0.5
        // The duration for one part of the animation (0.2 up and 0.2 down)
        hover.repeatCount = .infinity
        // The number of times the animation should repeat
        marco.layer.addAnimation(hover, forKey: "myHoverAnimation")
        girl.layer.addAnimation(hover, forKey: "girlhover")
        ////
        
        Question.selectable = false
        Question.editable = false
        AnswerView.editable = false
        AnswerView.selectable = false
        
        Question!.layer.borderWidth = 6
        
        Question!.layer.borderColor = UIColor.blackColor().CGColor
        Question!.layer.cornerRadius = 5
        
        AnswerView!.layer.borderWidth = 6
        AnswerView!.layer.borderColor = UIColor.blackColor().CGColor
        AnswerView!.layer.cornerRadius = 5
        
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        
        // Accessing the Choices.sqlite database and getting its location
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        var error:NSError?
        
        databasePath = docsDir.stringByAppendingPathComponent("Choices.sqlite")
        
       if filemgr.fileExistsAtPath(databasePath as String){
            println("FOUND!!!!")
        filemgr.removeItemAtPath(databasePath as String, error: &error)
            
        }

        if let bundle_path = NSBundle.mainBundle().pathForResource("Choices", ofType: "sqlite"){
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
        
        // Fetching required data from the database through suitable queries
        if mainDB.open(){
            println("DB is open and running...")
            
            
            let question1 = "SELECT Text FROM Communication WHERE QID= 'A' AND AID='$'"
            let answer1 =   "SELECT Text FROM Communication WHERE QID='A' AND AID='A1'"
            
            
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











