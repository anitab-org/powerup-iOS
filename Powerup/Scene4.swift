//
//  Scene4.swift


import UIKit

class Scene4: UIViewController {

    var eyeImage: UIImage!
    var faceImage: UIImage!
    var clothesImage: UIImage!
    var hairImage: UIImage!
    
    @IBOutlet weak var eyesview: UIImageView!
    @IBOutlet weak var hairview: UIImageView!
    @IBOutlet weak var faceview: UIImageView!
    @IBOutlet weak var clothesview: UIImageView!
    
    @IBOutlet weak var mar_text: UITextView!
    @IBOutlet weak var answerViewA: UITextView!
    @IBOutlet weak var answerViewB: UITextView!
    
    var databasePath = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eyesview.image = eyeImage
        hairview.image = hairImage
        faceview.image = faceImage
        clothesview.image = clothesImage
        
        // Back Button of navigation controller hidden
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        mar_text.isEditable = false
        mar_text.isSelectable = false
        
        answerViewA.isEditable = false
        answerViewA.isSelectable = false
        
        answerViewB.isEditable = false
        answerViewB.isSelectable = false
        
        mar_text!.layer.borderWidth = 6
        mar_text!.layer.borderColor = UIColor.black.cgColor
        mar_text!.layer.cornerRadius = 5
        
        answerViewA!.layer.borderWidth = 6
        answerViewA!.layer.borderColor = UIColor.black.cgColor
        answerViewA!.layer.cornerRadius = 5
        
        answerViewB!.layer.borderWidth = 6
        answerViewB!.layer.borderColor = UIColor.black.cgColor
        answerViewB!.layer.cornerRadius = 5


//        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).appendingPathComponent(
            "mainDatabase.sqlite") as NSString
        
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if (mainDB?.open())!{
            let question = "SELECT QDescription FROM Question Where QID=4"
            let Aoption = "SELECT ADescription FROM Answer WHERE AID=5"
            let Boption = "SELECT ADescription FROM Answer WHERE AID=7"
            
            let qresults:FMResultSet? = mainDB?.executeQuery(question,
                withArgumentsIn: nil)
            
            let aresults:FMResultSet? = mainDB?.executeQuery(Aoption,
                withArgumentsIn: nil)
            let bresults:FMResultSet? = mainDB?.executeQuery(Boption,
                withArgumentsIn: nil)
            
            
            if qresults?.next() == true
            {
                mar_text.text = qresults?.string(forColumn: "QDescription")
            }
            if aresults?.next() == true
            {
                answerViewA.text = aresults?.string(forColumn: "ADescription")
                
                }
            if bresults?.next() == true
            {
                answerViewB.text = bresults?.string(forColumn: "ADescription")
                                
            }
        }
        mainDB?.close()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toScene5"
        {
            if let destinationVC = segue.destination as? Scene5  {
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
        }
        if segue.identifier == "toScene74"
        {
            if let destinationVC = segue.destination as? Scene7  {
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
        }

    }

    

}
