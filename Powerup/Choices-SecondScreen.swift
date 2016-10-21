
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

        Question.isEditable = false
        Question.isSelectable = false
        
        AnswerView2.isEditable = false
        AnswerView2.isSelectable = false
        AnswerView3.isEditable = false
        AnswerView3.isSelectable = false
        
        
        Question!.layer.borderWidth = 6
        Question!.layer.borderColor = UIColor.black.cgColor
        Question!.layer.cornerRadius = 5
        
        AnswerView1!.layer.borderWidth = 6
        AnswerView1!.layer.borderColor = UIColor.black.cgColor
        AnswerView1!.layer.cornerRadius = 5
        
        AnswerView2!.layer.borderWidth = 6
        AnswerView2!.layer.borderColor = UIColor.black.cgColor
        AnswerView2!.layer.cornerRadius = 5
        
        AnswerView3!.layer.borderWidth = 6
        AnswerView3!.layer.borderColor = UIColor.black.cgColor
        AnswerView3!.layer.cornerRadius = 5
        
        
        // Accessing the database
        let filemgr = FileManager.default
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
        .userDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).appendingPathComponent(
        "Choices.sqlite") as NSString
        
        if filemgr.fileExists(atPath: databasePath as String){
        print("FOUND!!!!")
        
        }
        
        
        let mainDB = FMDatabase(path: databasePath as String)
        if mainDB == nil{
        print("Error: \(mainDB?.lastErrorMessage())")
        }
        
        
        if (mainDB?.open())!{
        

        let question2 = "SELECT Text FROM Communication WHERE QID='B' AND AID='$'"
        let answer2a =  "SELECT Text FROM Communication WHERE QID='B' AND AID='B1'"
        let answer2b =  "SELECT Text FROM Communication WHERE QID='B' AND AID='B2'"
        let answer2c =  "SELECT Text FROM Communication WHERE QID='B' AND AID='B3'"
       
        
        let qresults:FMResultSet? = mainDB?.executeQuery(question2,
        withArgumentsIn: nil)
        
        let aresults:FMResultSet? = mainDB?.executeQuery(answer2a,
        withArgumentsIn: nil)
        let bresults:FMResultSet? = mainDB?.executeQuery(answer2b,
        withArgumentsIn: nil)
        let cresults:FMResultSet? = mainDB?.executeQuery(answer2c,
            withArgumentsIn: nil)
        
        
        if qresults?.next() == true {
        Question.text = qresults?.string(forColumn: "Text")
        }
        
        if aresults?.next() == true {
        AnswerView1.text = aresults?.string(forColumn: "Text")
        }
        if bresults?.next() == true {
        AnswerView2.text = bresults?.string(forColumn: "Text")
        }
        if cresults?.next() == true {
        AnswerView3.text = cresults?.string(forColumn: "Text")
        }
        
        }
    

    
        
        
        
    mainDB?.close()
        
        
    }

    
    @IBAction func Answer1Button(_ sender: UIButton) {
    }
    
    
    @IBAction func Answer2Button(_ sender: UIButton) {
    }
 
    
    
    @IBAction func Answer3Button(_ sender: UIButton) {
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFourth"
        {
            if let destinationVC = segue.destination as? Choices_FourthScreen  {
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
        }
        if segue.identifier == "toThird"
        {
            if let destinationVC = segue.destination as? Choices_ThirdScreen  {
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
        }
        if segue.identifier == "toFifth"
        {
            if let destinationVC = segue.destination as? Choices_FifthScreen  {
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
        }
    }


    
}
