//
//  SecondViewController.swift


import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var S2Marcello: UITextField!
    
    @IBOutlet weak var S2Rosie: UITextField!
  
    @IBOutlet weak var eyesview: UIImageView!
    @IBOutlet weak var hairview: UIImageView!
    @IBOutlet weak var faceview: UIImageView!
    @IBOutlet weak var clothesview: UIImageView!
    
    var eyeImage: UIImage!
    var faceImage: UIImage!
    var clothesImage: UIImage!
    var hairImage: UIImage!
    
    //var counter = 0
    
    var databasePath = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eyesview.image = eyeImage
        hairview.image = hairImage
        faceview.image = faceImage
        clothesview.image = clothesImage
        
        // Back Button of navigation controller hidden
        self.navigationItem.setHidesBackButton(true, animated:true);

        S2Marcello!.layer.borderWidth = 6
        S2Marcello!.layer.borderColor = UIColor.black.cgColor
        S2Marcello!.layer.cornerRadius = 5
        
        S2Rosie!.layer.borderWidth = 6
        S2Rosie!.layer.borderColor = UIColor.black.cgColor
        S2Rosie!.layer.cornerRadius = 5
        
        
        //let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).appendingPathComponent(
            "mainDatabase.sqlite") as NSString
        
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if (mainDB?.open())! {
            let question = "SELECT QDescription FROM Question Where QID=3"
            let answer = "SELECT ADescription FROM Answer WHERE AID=15"
            
            let qresults:FMResultSet? = mainDB?.executeQuery(question,
                withArgumentsIn: nil)
            
            let aresults:FMResultSet? = mainDB?.executeQuery(answer,
                withArgumentsIn: nil)
            
            if qresults?.next() == true {
                S2Marcello.text = qresults?.string(forColumn: "QDescription")
            }
            
            if aresults?.next() == true{
                S2Rosie.text = aresults?.string(forColumn: "ADescription")
                
            }
        }
        mainDB?.close()
        
    }

    
    // Conveying End of Scenario to Map Screen so that Level 1 can't be clicked again, value of counter copied to numberToDisplay field of MapScreen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "level2end"
        {
            if let destinationVC = segue.destination as? MapScreen{
                //counter++
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
        }
        
    }

}
