
//  Choices-SixthScreen.swift
//  Database


import UIKit

class Choices_SixthScreen: UIViewController {

    
    
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    
    @IBOutlet weak var continueImage: UIImageView!
    @IBOutlet weak var continueToEnd: UIButton!
        var databasePath = NSString()
        var points = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueToEnd.hidden = true
        continueImage.hidden = true
        
        labelView.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
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
            let comment1 = "SELECT Text FROM ChoicesTable WHERE QID=6 AND RefID='$'"
            let comment2 = "SELECT Text FROM ChoicesTable WHERE QID=8 AND RefID='&'"
            
            let c1results:FMResultSet? = mainDB.executeQuery(comment1,
                withArgumentsInArray: nil)
            let c2results:FMResultSet? = mainDB.executeQuery(comment2,
                withArgumentsInArray: nil)
            
            
            
            if c1results?.next() == true {
                labelView.text = c1results?.stringForColumn("Text")
                
            }
            
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
                        self.continueToEnd.alpha = 1.0
                        }, completion: {
                            (finished: Bool) -> Void in
                            self.continueToEnd.hidden = false
                            self.continueImage.hidden = false
                           // self.mapScreen.hidden = false
                           // self.replay.hidden = false
                            
                    })
            })
            
        }
        
        
    
    }

    @IBAction func continueButton(sender: UIButton) {
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "assertive"
        {
            if let destinationVC = segue.destinationViewController as? Choices_EndScreen{
                
                destinationVC.numberToDisplay = points
            }
        }
    }
}

    


