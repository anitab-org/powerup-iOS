
//  Choices-FourthScreen.swift


import UIKit

class Choices_FourthScreen: UIViewController {

    var eyeImage: UIImage!
    var faceImage: UIImage!
    var clothesImage: UIImage!
    var hairImage: UIImage!
    
    @IBOutlet weak var eyesview: UIImageView!
    @IBOutlet weak var hairview: UIImageView!
    @IBOutlet weak var faceview: UIImageView!
    @IBOutlet weak var clothesview: UIImageView!
    
    @IBOutlet weak var Question: UITextView!
    
    @IBOutlet weak var AnswerView1: UITextField!
    
    @IBOutlet weak var AnswerView2: UITextView!
    
    @IBOutlet weak var AnswerView3: UITextView!
    
    var databasePath = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eyesview.image = eyeImage
        hairview.image = hairImage
        faceview.image = faceImage
        clothesview.image = clothesImage
        
        // Back Button of navigation controller hidden
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        Question.editable = false
        Question.selectable = false
        AnswerView2.editable = false
        AnswerView2.selectable = false
        
        Question!.layer.borderWidth = 6
        Question!.layer.borderColor = UIColor.blackColor().CGColor
        Question!.layer.cornerRadius = 5
        
        AnswerView1!.layer.borderWidth = 6
        AnswerView1!.layer.borderColor = UIColor.blackColor().CGColor
        AnswerView1!.layer.cornerRadius = 5
        
        AnswerView2!.layer.borderWidth = 6
        AnswerView2!.layer.borderColor = UIColor.blackColor().CGColor
        AnswerView2!.layer.cornerRadius = 5
        
        AnswerView3!.layer.borderWidth = 6
        AnswerView3!.layer.borderColor = UIColor.blackColor().CGColor
        AnswerView3!.layer.cornerRadius = 5
        
        
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        
        databasePath = docsDir.stringByAppendingPathComponent(
            "Choices.sqlite")
        
        if filemgr.fileExistsAtPath(databasePath as String){
            println("FOUND!!!!")
            
        }
        
        
        let mainDB = FMDatabase(path: databasePath as String)
        if mainDB == nil{
            println("Error: \(mainDB.lastErrorMessage())")
        }
        
        
        if mainDB.open(){
            
            
            let question4 = "SELECT Text FROM Communication WHERE QID='D' AND AID='$'"
            let answer4a =  "SELECT Text FROM Communication WHERE QID='D' AND AID='D1'"
            let answer4b =  "SELECT Text FROM Communication WHERE QID='D' AND AID='D2'"
            let answer4c =  "SELECT Text FROM Communication WHERE QID='D' AND AID='D3'"
            
            
            let qresults:FMResultSet? = mainDB.executeQuery(question4,
                withArgumentsInArray: nil)
            
            let aresults:FMResultSet? = mainDB.executeQuery(answer4a,
                withArgumentsInArray: nil)
            let bresults:FMResultSet? = mainDB.executeQuery(answer4b,
                withArgumentsInArray: nil)
            let cresults:FMResultSet? = mainDB.executeQuery(answer4c,
                withArgumentsInArray: nil)
            
            
            if qresults?.next() == true {
                Question.text = qresults?.stringForColumn("Text")
            }
            
            if aresults?.next() == true {
                AnswerView1.text = aresults?.stringForColumn("Text")
            }
            if bresults?.next() == true {
                AnswerView2.text = bresults?.stringForColumn("Text")
            }
            if cresults?.next() == true {
                AnswerView3.text = cresults?.stringForColumn("Text")
            }
            
        }
        
        
        
        
        
        
        mainDB.close()
        
        
    }

    @IBAction func Answer1Button(sender: UIButton) {
    }
   
    @IBAction func Answer2Button(sender: UIButton) {
    }
    
    
    @IBAction func Answer3Button(sender: UIButton) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toThree"
        {
            if let destinationVC = segue.destinationViewController as? Choices_ThirdScreen  {
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
        }
        if segue.identifier == "toSix"
        {
            if let destinationVC = segue.destinationViewController as? Choices_SixthScreen  {
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
        }
        if segue.identifier == "toFive"
        {
            if let destinationVC = segue.destinationViewController as? Choices_FifthScreen  {
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
        }
    }


}
