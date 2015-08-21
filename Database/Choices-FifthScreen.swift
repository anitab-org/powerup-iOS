//
//  Choices-FifthScreen.swift
//  Database

import UIKit

class Choices_FifthScreen: UIViewController {

     @IBOutlet weak var labelView: UILabel!
    
    @IBOutlet weak var friendImage: UIImageView!
    
    @IBOutlet weak var continueImage: UIImageView!
    @IBOutlet weak var continuetoEnd: UIButton!
    var databasePath = NSString()
    var points = 0
    var passString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        labelView!.layer.borderWidth = 6
        labelView!.layer.borderColor = UIColor.blackColor().CGColor
        labelView!.layer.cornerRadius = 5
    
        
        labelView.lineBreakMode = .ByWordWrapping
        labelView.numberOfLines = 0
        
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        
        databasePath = docsDir.stringByAppendingPathComponent(
            "Choices.sqlite")
        
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        
        if mainDB.open(){
            let comment1 = "SELECT Text FROM Communication WHERE QID='E' AND AID='$'"
            let comment2 = "SELECT Text FROM Communication WHERE QID='I' AND AID='$'"
            
            
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

            
            /*
            UIView.animateWithDuration(2.0, delay: 5.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.labelView.alpha = 0.0
                }, completion: {
                    (finished: Bool) -> Void in
                    self.friendImage.hidden = true
                    //Once the label is completely invisible, set the text and fade it back in
                    if c2results?.next() == true {
                        self.labelView.text = c2results?.stringForColumn("Text")
                    }
                    // Fade in
                    UIView.animateWithDuration(2.0, delay: 2.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        self.labelView.alpha = 1.0
                        self.continuetoEnd.alpha = 1.0
                        }, completion: {
                            (finished: Bool) -> Void in
                         self.continueImage.hidden = false
                            self.continuetoEnd.hidden = false
                            
                    })
            })
*/
            
        }

        
        
    
        
    }
    

    
    @IBAction func continueButton(sender: UIButton) {
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "aggressive"
        {
            if let destinationVC = segue.destinationViewController as? Choices_EndScreen{
                destinationVC.sampleText = passString
                println("\(passString)")
                destinationVC.numberToDisplay = points
            }
        }
    }


}
