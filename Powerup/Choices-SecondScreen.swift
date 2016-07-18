
//  Choices-SecondScreen.swift



import UIKit

class Choices_SecondScreen: UIViewController {
    
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
        AnswerView3.editable = false
        AnswerView3.selectable = false
        
        
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
        
        
        // Accessing the database
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
        

        let question2 = "SELECT Text FROM Communication WHERE QID='B' AND AID='$'"
        let answer2a =  "SELECT Text FROM Communication WHERE QID='B' AND AID='B1'"
        let answer2b =  "SELECT Text FROM Communication WHERE QID='B' AND AID='B2'"
        let answer2c =  "SELECT Text FROM Communication WHERE QID='B' AND AID='B3'"
       
        
        let qresults:FMResultSet? = mainDB.executeQuery(question2,
        withArgumentsInArray: nil)
        
        let aresults:FMResultSet? = mainDB.executeQuery(answer2a,
        withArgumentsInArray: nil)
        let bresults:FMResultSet? = mainDB.executeQuery(answer2b,
        withArgumentsInArray: nil)
        let cresults:FMResultSet? = mainDB.executeQuery(answer2c,
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
        if segue.identifier == "toFourth"
        {
            if let destinationVC = segue.destinationViewController as? Choices_FourthScreen  {
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
        }
        if segue.identifier == "toThird"
        {
            if let destinationVC = segue.destinationViewController as? Choices_ThirdScreen  {
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
        }
        if segue.identifier == "toFifth"
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
