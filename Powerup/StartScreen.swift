//
//  StartScreen.swift
//


import UIKit

class StartScreen: UIViewController {
    
    var databasePath = NSString()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var MiniGamesButton: UIButton!
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var PowerUp: UITextView!
    
    var eyeImage: UIImage!
    var faceImage: UIImage!
    var clothesImage: UIImage!
    var hairImage: UIImage!
    
    // For orientation - set to Portrait
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Back Button of navigation controller is hidden on home screen
        self.navigationItem.setHidesBackButton(true, animated:true);
        
    }
    
    // Start button is clickable
    @IBAction func Start(sender: UIButton) {
        var c = defaults.integerForKey("newuser")
        
        if(c == 0 ){
            var alertView = UIAlertView();
            alertView.addButtonWithTitle("OK");
            alertView.title = "MESSAGE!!!";
            alertView.message = "Press New User First!!";
            alertView.show();
        }
        else{
            let filemgr = NSFileManager.defaultManager()
            let dirPaths =
            NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                .UserDomainMask, true)
            
            let docsDir = dirPaths[0] as! String
            
            databasePath = docsDir.stringByAppendingPathComponent(
                "mainDatabase.sqlite")
            
            let mainDB = FMDatabase(path: databasePath as String)
            
            if mainDB.open(){
                let face = "SELECT Face FROM Avatar Where ID='\(c)'"
                let clothes = "SELECT Clothes FROM Avatar WHERE ID='\(c)'"
                let hair = "SELECT Hair FROM Avatar WHERE ID='\(c)'"
                let eyes = "SELECT Eyes FROM Avatar WHERE ID='\(c)'"
                
                let fresults:FMResultSet? = mainDB.executeQuery(face,
                    withArgumentsInArray: nil)
                
                let cresults:FMResultSet? = mainDB.executeQuery(clothes,
                    withArgumentsInArray: nil)
                let hresults:FMResultSet? = mainDB.executeQuery(hair,
                    withArgumentsInArray: nil)
                let eresults:FMResultSet? = mainDB.executeQuery(eyes,
                    withArgumentsInArray: nil)
                
                
                if fresults?.next() == true
                {
                    let fRes = fresults?.stringForColumn("Face")
                    faceImage = UIImage(named: fRes!)
                }
                if cresults?.next() == true
                {
                    let cRes = cresults?.stringForColumn("Clothes")
                    clothesImage = UIImage(named: cRes!)
                }
                if hresults?.next() == true
                {
                    let hRes = hresults?.stringForColumn("Hair")
                    hairImage = UIImage(named: hRes!)
                }
                if eresults?.next() == true
                {
                    let eRes = eresults?.stringForColumn("Eyes")
                    eyeImage = UIImage(named: eRes!)
                }
            }
            mainDB.close()
            performSegueWithIdentifier("startToMap", sender: self)
        }
        
    }
    
    @IBAction func NewUser(sender: UIButton) {
        var c = defaults.integerForKey("newuser")
        c++
        defaults.setInteger(c, forKey: "newuser")
        
        var x = defaults.integerForKey("backtomap")
        x = 0
        defaults.setInteger(x, forKey: "backtomap")
    }
    
    // minigames not clickable
    @IBAction func MiniGames(sender: UIButton) {
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startToMap"
        {
            var c = defaults.integerForKey("newuser")
            if (c > 0){
                
                if let destinationVC = segue.destinationViewController as? MapScreen{
                    println("Passing data to Map from Start button!!")
                    destinationVC.eyeImage = eyeImage
                    destinationVC.hairImage = hairImage
                    destinationVC.clothesImage = clothesImage
                    destinationVC.faceImage = faceImage
                }
            }
        }
    }
    
    
}
