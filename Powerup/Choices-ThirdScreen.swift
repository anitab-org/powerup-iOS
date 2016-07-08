
//  Choices-ThirdScreen.swift



import UIKit

class Choices_ThirdScreen: UIViewController {

    
    var eyeImage: UIImage!
    var faceImage: UIImage!
    var clothesImage: UIImage!
    var hairImage: UIImage!
  
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var friendImage: UIImageView!
    
    @IBOutlet weak var continueImage: UIImageView!
    
    @IBOutlet weak var continueToEnd: UIButton!
    
    
    
    var databasePath = NSString()
    
    var points = 10
    var passString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Back Button of navigation controller hidden
        self.navigationItem.setHidesBackButton(true, animated:true);
        
       // Setting the label's border and making its corners rounded
        textLabel!.layer.borderWidth = 6
      textLabel!.layer.borderColor = UIColor.blackColor().CGColor
        textLabel!.layer.cornerRadius = 5
       
        // Making content in the label to be word wrapped(and not in center)
        textLabel.lineBreakMode = .ByWordWrapping
         textLabel.numberOfLines = 0
    
        
        // Accessing the database
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        
        databasePath = docsDir.stringByAppendingPathComponent(
            "Choices.sqlite")
        
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        // Queries to select appropriate content inside the textboxes
        if mainDB.open(){
            let comment1 = "SELECT Text FROM Communication WHERE QID='C' AND AID='$'"
            let comment2 = "SELECT Text FROM Communication WHERE QID='G' AND AID='$'"
           
            
            
            let c1results:FMResultSet? = mainDB.executeQuery(comment1,
                withArgumentsInArray: nil)
            
            let c2results:FMResultSet? = mainDB.executeQuery(comment2,
                withArgumentsInArray: nil)
            
            
            if c1results?.next() == true {
                textLabel.text = c1results?.stringForColumn("Text")
                
            }
            
            if c2results?.next() == true {
                var a = c2results?.stringForColumn("Text")
                passString = passString + a!
            }
            
        }
        
    }

   
    @IBAction func continueButton(sender: AnyObject) {
    }
  

    // Communicate to ending screen that passive mode of communication was chosen so that appropriate concluding mark can be displayed
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "passive"
        {
            if let destinationVC = segue.destinationViewController as? Choices_EndScreen{
                
                
                destinationVC.numberToDisplay = points
                destinationVC.sampleText = passString
                println("\(passString)")
                
                destinationVC.eyeImage = eyeImage
                destinationVC.hairImage = hairImage
                destinationVC.clothesImage = clothesImage
                destinationVC.faceImage = faceImage
                }
            
            }
        }
    }
    
    
  
    
    
    
   

