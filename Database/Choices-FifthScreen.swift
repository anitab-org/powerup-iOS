//
//  Choices-FifthScreen.swift
//  Database

import UIKit

class Choices_FifthScreen: UIViewController {

    //@IBOutlet weak var CommentView: UITextView!
    
    @IBOutlet weak var mapScreen: UIButton!
    @IBOutlet weak var replay: UIButton!
    @IBOutlet weak var labelView: UILabel!
    
    @IBOutlet weak var friendImage: UIImageView!
    
    var databasePath = NSString()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapScreen.hidden = true
        replay.hidden = true
        
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
            let comment1 = "SELECT Text FROM ChoicesTable WHERE QID=5 AND RefID='$'"
            let comment2 = "SELECT Text FROM ChoicesTable WHERE QID=7 AND RefID='&'"
            
            
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
                        }, completion: {
                            (finished: Bool) -> Void in
                            self.mapScreen.hidden = false
                            self.replay.hidden = false
                            
                    })
            })
            
        }

        
        
    
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func mapScreenButton(sender: UIButton) {
    }
    
    @IBAction func replayButton(sender: UIButton) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "nextView"
        {
            if let destinationVC = segue.destinationViewController as? MapScreen{
                counter++
                destinationVC.numberToDisplay = counter
            }
        }
        
    }


}
