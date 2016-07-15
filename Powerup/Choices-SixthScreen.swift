
//  Choices-SixthScreen.swift



import UIKit

class Choices_SixthScreen: UIViewController {

    var eyeImage: UIImage!
    var faceImage: UIImage!
    var clothesImage: UIImage!
    var hairImage: UIImage!
    
    
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    
    @IBOutlet weak var continueImage: UIImageView!
    @IBOutlet weak var continueToEnd: UIButton!
        var databasePath = NSString()
        var points = 20
        var passString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Back Button of navigation controller hidden
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        // Setting the label's border and making its corners rounded
        labelView!.layer.borderWidth = 6
        labelView!.layer.borderColor = UIColor.blackColor().CGColor
        labelView!.layer.cornerRadius = 5
        
        // Making content in the label to be word wrapped(and not in center)
        labelView.lineBreakMode = .ByWordWrapping
        labelView.numberOfLines = 0
        
        // Accessing the database
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
    
        let docsDir = dirPaths[0] as! String
        
        databasePath = docsDir.stringByAppendingPathComponent(
            "Choices.sqlite")
        
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        
        if mainDB.open(){
            let comment1 = "SELECT Text FROM Communication WHERE QID='F' AND AID='$'"
            let comment2 = "SELECT Text FROM Communication WHERE QID='H' AND AID='$'"
            
            let c1results:FMResultSet? = mainDB.executeQuery(comment1,
                withArgumentsInArray: nil)
            let c2results:FMResultSet? = mainDB.executeQuery(comment2,
                withArgumentsInArray: nil)
            
            
            
            if c1results?.next() == true {
                labelView.text = c1results?.stringForColumn("Text")
                
            }
            
            if c2results?.next() == true {
                var a = c2results?.stringForColumn("Text")
                passString = passString + a!
            }

            
            
            
        }
        
        
    
    }

    @IBAction func continueButton(sender: UIButton) {
    }
    
    // Communicate to ending screen that assertive mode of communication was chosen so that appropriate concluding mark can be displayed
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "assertive"
        {
            if let destinationVC = segue.destinationViewController as? Choices_EndScreen{
                
                destinationVC.sampleText = passString
                println("\(passString)")
                destinationVC.numberToDisplay = points
                
                destinationVC.eyeImage = eyeImage
                destinationVC.hairImage = hairImage
                destinationVC.clothesImage = clothesImage
                destinationVC.faceImage = faceImage
            }
        }
    }
}

    


