//
//  Choices-Continue.swift
//  
//
//  Created by Andrew  on 1/9/16.
//
//

import UIKit

class Choices_Continue: UIViewController {

    var version = 0
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    
    @IBOutlet weak var continueImage: UIImageView!
    @IBOutlet weak var continueToEnd: UIButton!
    var databasePath = NSString()
    var points = 0
    var passString = ""
    var comment1 = ""
    var comment2 = ""

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
            if(version == 1){
                comment1 = "SELECT Text FROM Communication WHERE QID='C' AND AID='$'"
                comment2 = "SELECT Text FROM Communication WHERE QID='G' AND AID='$'"
            }else if(version == 2){
                comment1 = "SELECT Text FROM Communication WHERE QID='F' AND AID='$'"
                comment2 = "SELECT Text FROM Communication WHERE QID='H' AND AID='$'"
            }else{
                comment1 = "SELECT Text FROM Communication WHERE QID='E' AND AID='$'"
                comment2 = "SELECT Text FROM Communication WHERE QID='I' AND AID='$'"
            }
            
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func continueButton(sender: UIButton) {
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if let destinationVC = segue.destinationViewController as? Choices_EndScreen{
                if(version == 1){
                    points = 10
                }
                else if(version == 2){
                    points = 20
                }
                else{
                    points = 0
                }
                destinationVC.sampleText = passString
                println("\(passString)")
                destinationVC.numberToDisplay = points
            }
    }

}
