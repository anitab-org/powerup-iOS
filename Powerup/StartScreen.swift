//
//  StartScreen.swift
//

import UIKit

class StartScreen: UIViewController {
    
    var databasePath = NSString()
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var MiniGamesButton: UIButton!
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var PowerUp: UITextView!
    
    var eyeImage: UIImage!
    var faceImage: UIImage!
    var clothesImage: UIImage!
    var hairImage: UIImage!
    
    // For orientation - set to Portrait
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [.portrait]
        //return UIInterfaceOrientation.Portrait.rawValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Back Button of navigation controller is hidden on home screen
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        // setting the orientation to portrait
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
    }
    
    // Start button is clickable
    @IBAction func Start(_ sender: UIButton) {
        let c = defaults.integer(forKey: "newuser")
        
        if(c == 0 ){
            let alert = UIAlertController(title: "MESSAGE!!!", message:"Press New User First!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
            self.present(alert, animated: true){}
        }
        else{
            //let filemgr = NSFileManager.defaultManager()
            let dirPaths =
            NSSearchPathForDirectoriesInDomains(.documentDirectory,
                .userDomainMask, true)
            
            let docsDir = dirPaths[0] 
            
            databasePath = (docsDir as NSString).appendingPathComponent(
                "mainDatabase.sqlite") as NSString
            
            let mainDB = FMDatabase(path: databasePath as String)
            
            if (mainDB?.open())!{
                let face = "SELECT Face FROM Avatar Where ID='\(c)'"
                let clothes = "SELECT Clothes FROM Avatar WHERE ID='\(c)'"
                let hair = "SELECT Hair FROM Avatar WHERE ID='\(c)'"
                let eyes = "SELECT Eyes FROM Avatar WHERE ID='\(c)'"
                
                let fresults:FMResultSet? = mainDB?.executeQuery(face,
                    withArgumentsIn: nil)
                
                let cresults:FMResultSet? = mainDB?.executeQuery(clothes,
                    withArgumentsIn: nil)
                let hresults:FMResultSet? = mainDB?.executeQuery(hair,
                    withArgumentsIn: nil)
                let eresults:FMResultSet? = mainDB?.executeQuery(eyes,
                    withArgumentsIn: nil)
                
                
                if fresults?.next() == true
                {
                    let fRes = fresults?.string(forColumn: "Face")
                    faceImage = UIImage(named: fRes!)
                }
                if cresults?.next() == true
                {
                    let cRes = cresults?.string(forColumn: "Clothes")
                    clothesImage = UIImage(named: cRes!)
                }
                if hresults?.next() == true
                {
                    let hRes = hresults?.string(forColumn: "Hair")
                    hairImage = UIImage(named: hRes!)
                }
                if eresults?.next() == true
                {
                    let eRes = eresults?.string(forColumn: "Eyes")
                    eyeImage = UIImage(named: eRes!)
                }
            }
            mainDB?.close()
            performSegue(withIdentifier: "startToMap", sender: self)
        }
        
    }
    
    @IBAction func NewUser(_ sender: UIButton) {
        var c = defaults.integer(forKey: "newuser")
        c += 1
        defaults.set(c, forKey: "newuser")
        
        var x = defaults.integer(forKey: "backtomap")
        x = 0
        defaults.set(x, forKey: "backtomap")
    }
    
    // minigames not clickable
    @IBAction func MiniGames(_ sender: UIButton) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startToMap"
        {
            let c = defaults.integer(forKey: "newuser")
            if (c > 0){
                
                if let destinationVC = segue.destination as? MapScreen{
                    print("Passing data to Map from Start button!!")
                    destinationVC.eyeImage = eyeImage
                    destinationVC.hairImage = hairImage
                    destinationVC.clothesImage = clothesImage
                    destinationVC.faceImage = faceImage
                }
            }
        }
    }
    
    
}
