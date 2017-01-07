// Screen 1 for Sex- Scenario

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var mar_text: UITextView!

    @IBOutlet weak var answerViewA: UITextField!
    @IBOutlet weak var answerViewB: UITextField!
    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var eyesview: UIImageView!
    @IBOutlet weak var hairview: UIImageView!
    @IBOutlet weak var faceview: UIImageView!
    @IBOutlet weak var clothesview: UIImageView!
    // Created an IBOutlet for the imageview
   
    @IBOutlet weak var charBG: UIImageView!
    
    
    
    var eyeImage: UIImage!
    var faceImage: UIImage!
    var clothesImage: UIImage!
    var hairImage: UIImage!

    
    var databasePath = NSString()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eyesview.image = eyeImage
        hairview.image = hairImage
        faceview.image = faceImage
        clothesview.image = clothesImage
        if clothesview.image == nil {
            charBG.image = UIImage(named: "endingscreen1")
            
        }
        else{
        charBG.image = UIImage(named: "body")
        
        }
        
        
        // Hide back button of navigation controller
        self.navigationItem.setHidesBackButton(false, animated:true);
        
        // Making textview non editable and non-selectable so that user can't change the content
        
        mar_text.isEditable = false
        mar_text.isSelectable = false
        
        
        // Borders and rounded corners for textfields and textviews
        mar_text!.layer.borderWidth = 6
        mar_text!.layer.borderColor = UIColor.black.cgColor
        mar_text!.layer.cornerRadius = 5
        
        answerViewA!.layer.borderWidth = 6
        answerViewA!.layer.borderColor = UIColor.black.cgColor
        answerViewA!.layer.cornerRadius = 5
        
        answerViewB!.layer.borderWidth = 6
        answerViewB!.layer.borderColor = UIColor.black.cgColor
        answerViewB!.layer.cornerRadius = 5
        
        bgImage.image = UIImage(named: "endingscreen")
        
        
        // Fetching database content via FMDB wrapper
        
        let filemgr = FileManager.default
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        
        let docsDir = dirPaths[0] 
        var error: NSError?
        
        databasePath = (docsDir as NSString).appendingPathComponent(
            "mainDatabase.sqlite") as NSString
        
        
        if filemgr.fileExists(atPath: databasePath as String){
            print("FOUND!!!!")
            do {
                try filemgr.removeItem(atPath: databasePath as String)
               
                
            } catch let error1 as NSError {
                error = error1
            }
            
        }
        
        if let bundle_path = Bundle.main.path(forResource: "mainDatabase", ofType: "sqlite"){
            print("\(bundle_path)")
            
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
            if mainDB == nil{
                print("Error: \(mainDB?.lastErrorMessage())")
                
            }
        
       /* let result = mainDB?.executeQuery("SELECT COUNT(*) FROM myTable", withArgumentsInArray: [])
        if result.next() {
            let count = result.intForColumnIndex(0)
            if count > 0 {
                print("SomeData")
            } else {
                print("Empty Table")
            }
        } else {
            print("Database error")
        }
        */

        
        
        // opening the database and extracting content through suitable queries
           if (mainDB?.open())!{
                let question = "SELECT QDescription FROM Question Where QID=1"
                let Aoption = "SELECT ADescription FROM Answer WHERE QID=1 AND AID=1"
                let Boption = "SELECT ADescription FROM Answer WHERE QID=1 AND AID=2"
            
            let qresults:FMResultSet? = mainDB?.executeQuery(question,
                withArgumentsIn: nil)
            
            let aresults:FMResultSet? = mainDB?.executeQuery(Aoption,
                withArgumentsIn: nil)
            let bresults:FMResultSet? = mainDB?.executeQuery(Boption,
                withArgumentsIn: nil)
            
            
            if qresults?.next() == true {
                mar_text.text = qresults?.string(forColumn: "QDescription")
               
                
            }
            
            if aresults?.next() == true {
        answerViewA.text = aresults?.string(forColumn: "ADescription")
                }
            if bresults?.next() == true {
                answerViewB.text = bresults?.string(forColumn: "ADescription")
                

            }
            
        
        }
        
        mainDB?.close()
                
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toScene2"
        {
            if let destinationVC = segue.destination as? SecondViewController  {
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
        }
        if segue.identifier == "toScene3"
        {
            if let destinationVC = segue.destination as? ThirdViewController  {
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
        }
    }
    
    
    // clickable Option A button

    @IBAction func find(_ sender: UIButton) {
        
    }

 // clickable Option B button
    @IBAction func Boption(_ sender: UIButton) {
           }
    

}
