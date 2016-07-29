//
//  Choices-FirstScreen.swift


import UIKit

class Choices_FirstScreen: UIViewController {
    
    @IBOutlet weak var eyesview: UIImageView!
    @IBOutlet weak var hairview: UIImageView!
    @IBOutlet weak var faceview: UIImageView!
    @IBOutlet weak var clothesview: UIImageView!
    
    var eyeImage: UIImage!
    var faceImage: UIImage!
    var clothesImage: UIImage!
    var hairImage: UIImage!
    
    
    @IBOutlet weak var Question: UITextView!
    
    @IBOutlet weak var AnswerView: UITextView!
    
    
    var databasePath = NSString()
    
    // Orientation - set to Portrait
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [.Portrait]
       }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eyesview.image = eyeImage
        hairview.image = hairImage
        faceview.image = faceImage
        clothesview.image = clothesImage
        
        // Back Button of navigation controller hidden
        self.navigationItem.setHidesBackButton(true, animated:true);
        
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
        
        let docsDir = dirPaths[0] 
        var error:NSError?
        
        databasePath = (docsDir as NSString).stringByAppendingPathComponent("Choices.sqlite")
        
       if filemgr.fileExistsAtPath(databasePath as String){
            print("FOUND!!!")
            do {
                try filemgr.removeItemAtPath(databasePath as String)
            } catch let error1 as NSError {
                error = error1
            }
            
        }

        if let bundle_path = NSBundle.mainBundle().pathForResource("Choices", ofType: "sqlite"){
        print("Test!")
            
        do {
            try filemgr.copyItemAtPath(bundle_path, toPath: databasePath as String)
                print("Success!!!")
        } catch let error1 as NSError {
            error = error1
                print("Failure")
            print(error?.localizedDescription)
            }
            }
        let mainDB = FMDatabase(path: databasePath as String)
        
        // Fetching required data from the database through suitable queries
        if mainDB.open(){
            print("DB is open and running...")
            
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "secondView"
        {
            if let destinationVC = segue.destinationViewController as? Choices_SecondScreen  {
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
        }
        
    }
    
}


