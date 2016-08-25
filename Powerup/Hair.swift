//
//  Hair.swift
//  Powerup

import UIKit

class Hair: UIViewController {
    
    var points = 0
    var idno = 0
    var databasePath = NSString()
    @IBOutlet weak var hairLabel: UILabel!
    @IBOutlet weak var paidLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var hairview: UIImageView!
    @IBOutlet weak var customhair: UIImageView!
    
    @IBOutlet weak var eyesview: UIImageView!
    @IBOutlet weak var clothesview: UIImageView!
    @IBOutlet weak var faceview: UIImageView!
    
    var eyeImage: UIImage!
    var faceImage: UIImage!
    var hairImage: UIImage!
    var originalhair: UIImage!
    var clothesImage: UIImage!
    
    var hair = ["hair2", "hair3", "hair4", "hair5", "hair6", "hair7", "hair8", "hair9", "hair10", "hair11"]
    var haircount = -1
    var hairtotal = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paidLabel.hidden = true
        paidLabel.transform = CGAffineTransformMakeRotation(-45 * CGFloat(M_PI) / 180.0)
        eyesview.image = eyeImage
        clothesview.image = clothesImage
        faceview.image = faceImage
        customhair.image = hairImage
        originalhair = hairImage
        hairview.image = UIImage(named: "\(hair[0]).png")
        
        //pointsLabel.text = "\(points)"
        
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).stringByAppendingPathComponent(
            "mainDatabase.sqlite")
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if mainDB.open(){
            let hairRes = "SELECT Points FROM Hair Where Name='\(hair[0])'"
            
            let hResults:FMResultSet? = mainDB.executeQuery(hairRes,
                withArgumentsInArray: nil)
            
            if hResults?.next() == true
            {
                hairLabel.text = hResults?.stringForColumn("Points")
            }
            let p = "SELECT Points FROM Score Where ID='\(idno)'"
            let presults:FMResultSet? = mainDB.executeQuery(p,
                                                            withArgumentsInArray: nil)
            
            if presults?.next() == true {
                pointsLabel.text = presults?.stringForColumn("Points")
            }
            
        }
        mainDB.close()
        
    }
    
    @IBAction func hairR(sender: AnyObject) {
        if(haircount + 1 < hairtotal){
            haircount += 1
        }
        hairview.image = UIImage(named: "\(hair[haircount]).png")
        customhair.image = UIImage(named: "\(hair[haircount]).png")
       
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).stringByAppendingPathComponent(
            "mainDatabase.sqlite")
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if mainDB.open(){
            let hairRes = "SELECT Points FROM Hair Where Name='\(hair[haircount])'"
            let check = "SELECT Purchased FROM Hair Where Name='\(hair[haircount])'"
            
            let hResults:FMResultSet? = mainDB.executeQuery(hairRes,
                                                            withArgumentsInArray: nil)
            let checkResults:FMResultSet? = mainDB.executeQuery(check,
                                                                withArgumentsInArray: nil)
            if hResults?.next() == true
            {
                hairLabel.text = hResults?.stringForColumn("Points")
                if checkResults?.next() == true{
                    let x = checkResults?.stringForColumn("Purchased")
                    let test:Int? = Int(x!)
                    if(test == 1){
                        paidLabel.hidden = false
                    }
                    else{
                        paidLabel.hidden = true
                    }
                }
            }
            
        }
        mainDB.close()
    }
    
    @IBAction func hairL(sender: AnyObject) {
        if(haircount > 0){
            haircount -= 1
        }
        if(haircount != -1){
        hairview.image = UIImage(named: "\(hair[haircount]).png")
        customhair.image = UIImage(named: "\(hair[haircount]).png")
        
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).stringByAppendingPathComponent(
            "mainDatabase.sqlite")
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if mainDB.open(){
            let hairRes = "SELECT Points FROM Hair Where Name='\(hair[haircount])'"
            let check = "SELECT Purchased FROM Hair Where Name='\(hair[haircount])'"
            
            let hResults:FMResultSet? = mainDB.executeQuery(hairRes,
                withArgumentsInArray: nil)
            let checkResults:FMResultSet? = mainDB.executeQuery(check,
                                                                withArgumentsInArray: nil)
            
            if hResults?.next() == true
            {
                hairLabel.text = hResults?.stringForColumn("Points")
                if checkResults?.next() == true{
                    let x = checkResults?.stringForColumn("Purchased")
                    let test:Int? = Int(x!)
                    if(test == 1){
                        paidLabel.hidden = false
                    }
                    else{
                        paidLabel.hidden = true
                    }
                }
            }
            
        }
        mainDB.close()
        }
    }
    
    @IBAction func Hair(sender: UIButton) {
        if(haircount == -1){
            return
        }
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
            NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                                                .UserDomainMask, true)
        
        let docsDir = dirPaths[0]
        var error: NSError?
        
        databasePath = (docsDir as NSString).stringByAppendingPathComponent(
            "mainDatabase.sqlite")
        
        if filemgr.fileExistsAtPath(databasePath as String){
            do {
                try filemgr.removeItemAtPath(databasePath as String)
            } catch let error1 as NSError {
                error = error1
            }
            
        }
        
        if let bundle_path = NSBundle.mainBundle().pathForResource("mainDatabase", ofType: "sqlite"){
            do {
                try filemgr.copyItemAtPath(bundle_path, toPath: databasePath as String)
            } catch let error1 as NSError {
                error = error1
                print("Failure")
                print(error?.localizedDescription)
            }
            
            let mainDB = FMDatabase(path: databasePath as String)
            if mainDB == nil{
                print("Error: \(mainDB.lastErrorMessage())")
            }
            
            // opening the database and extracting content through suitable queries
            if mainDB.open(){
                let p = "SELECT Points FROM Score Where ID='\(idno)'"
                let presults:FMResultSet? = mainDB.executeQuery(p,
                                                                withArgumentsInArray: nil)
                
                if presults?.next() == true {
                    print("Selected Points entry")
                    let x = presults?.stringForColumn("Points")
                    let hairRes = "SELECT Points FROM Hair Where Name='\(hair[haircount])'"
                    let hresults:FMResultSet? = mainDB.executeQuery(hairRes,
                                                                    withArgumentsInArray: nil)
                    print("x: \(x)")
                    
                    if hresults?.next() == true {
                        let y = hresults?.stringForColumn("Points")
                        print("y: \(y)")
                        let a:Int? = Int(x!)
                        let b:Int? = Int(y!)
                        
                        if(a >= b )
                        {
                            paidLabel.hidden = false
                            let query = "UPDATE Score SET Points='\(a!-b!)' WHERE ID='\(idno)'"
                            let addSuccess = mainDB.executeUpdate(query, withArgumentsInArray: nil)
                            if(!addSuccess){
                                print("Failed to add data to Avatar Table")
                            }
                            else
                            {
                                print("Success in updating score entry", terminator: "")
                            }
                            
                            pointsLabel.text = "\(a!-b!)"
                            let query2 = "UPDATE Hair SET Purchased=1 WHERE Name='\(hair[haircount])'"
                            let success2 = mainDB.executeUpdate(query2, withArgumentsInArray: nil)
                            if(!success2){
                                print("Failed to update Purchased Attribute")
                            }
                            else{
                                print("Success in updating purchased Attribute")
                            }
                            
                            if filemgr.fileExistsAtPath(bundle_path){
                                print("About to del bundle file")
                                do {
                                    try filemgr.removeItemAtPath(bundle_path)
                                } catch let error1 as NSError {
                                    error = error1
                                }
                            }
                            
                            do {
                                try filemgr.copyItemAtPath(databasePath as String, toPath: bundle_path)
                                print("replaced bundle path contents")
                                
                            } catch let error1 as NSError {
                                error = error1
                                print("Failure 2")
                                print(error?.localizedDescription)
                            }
                        }
                        else{
                            let alert = UIAlertController(title: "MESSAGE!!!", message:"You don't have sufficient Points to buy this!", preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                            self.presentViewController(alert, animated: true){}
                        }
                    }
                    
                }
            }
            mainDB.close()
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fromHair"
        {
            if let destinationVC = segue.destinationViewController as? DressingRoom2{
                destinationVC.idno = idno
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = originalhair
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
                
            }
        }
    }
}




