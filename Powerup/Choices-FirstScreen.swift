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
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [.portrait]
       }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eyesview.image = eyeImage
        hairview.image = hairImage
        faceview.image = faceImage
        clothesview.image = clothesImage
        
        // Back Button of navigation controller hidden
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        Question.isSelectable = false
        Question.isEditable = false
        AnswerView.isEditable = false
        AnswerView.isSelectable = false
        
        
        Question!.layer.borderWidth = 6
        Question!.layer.borderColor = UIColor.black.cgColor
        Question!.layer.cornerRadius = 5
        
        AnswerView!.layer.borderWidth = 6
        AnswerView!.layer.borderColor = UIColor.black.cgColor
        AnswerView!.layer.cornerRadius = 5
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        
        // Accessing the Choices.sqlite database and getting its location
        let filemgr = FileManager.default
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        
        let docsDir = dirPaths[0] 
        var error:NSError?
        
        databasePath = (docsDir as NSString).appendingPathComponent("Choices.sqlite") as NSString
        
       if filemgr.fileExists(atPath: databasePath as String){
            print("FOUND!!!")
            do {
                try filemgr.removeItem(atPath: databasePath as String)
            } catch let error1 as NSError {
                error = error1
            }
            
        }

        if let bundle_path = Bundle.main.path(forResource: "Choices", ofType: "sqlite"){
        print("Test!")
            
        do {
            try filemgr.copyItem(atPath: bundle_path, toPath: databasePath as String)
                print("Success!!!")
        } catch let error1 as NSError {
            error = error1
                print("Failure")
            print(error?.localizedDescription)
            }
            }
        let mainDB = FMDatabase(path: databasePath as String)
        
        // Fetching required data from the database through suitable queries
        if (mainDB?.open())!{
            print("DB is open and running...")
            
            let question1 = "SELECT Text FROM Communication WHERE QID= 'A' AND AID='$'"
            let answer1 =   "SELECT Text FROM Communication WHERE QID='A' AND AID='A1'"
            
            let qresults:FMResultSet? = mainDB?.executeQuery(question1,
                withArgumentsIn: nil)
            
            let aresults:FMResultSet? = mainDB?.executeQuery(answer1,
                withArgumentsIn: nil)
            
            if qresults?.next() == true {
                Question.text = qresults?.string(forColumn: "Text")
            }
            
            if aresults?.next() == true {
                AnswerView.text = aresults?.string(forColumn: "Text")
            }
        }
        mainDB?.close()
    
}
    
    
    @IBAction func AnswerButton(_ sender: UIButton) {
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "secondView"
        {
            if let destinationVC = segue.destination as? Choices_SecondScreen  {
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
        }
        
    }
    
}


