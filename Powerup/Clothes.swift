//
//  Clothes.swift
//  Powerup

import UIKit

class Clothes: UIViewController {

    var databasePath = NSString()
    @IBOutlet weak var clothesLabel: UILabel!
    @IBOutlet weak var paidLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var clothesview: UIImageView!
    @IBOutlet weak var customclothes: UIImageView!
   
    @IBOutlet weak var eyesview: UIImageView!
    @IBOutlet weak var hairview: UIImageView!
    @IBOutlet weak var faceview: UIImageView!
    
    var points = 0
    var idno = 0
    var eyeImage: UIImage!
    var faceImage: UIImage!
    var hairImage: UIImage!
    var clothesImage: UIImage!
    var originalclothes: UIImage!
    
    var clothes = ["cloth1", "cloth2", "cloth3", "cloth4", "cloth5", "cloth6", "cloth7", "cloth8", "cloth9"]
    var clothescount = -1
    var clothestotal = 9
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paidLabel.hidden = true
        paidLabel.transform = CGAffineTransformMakeRotation(-45 * CGFloat(M_PI) / 180.0)
        eyesview.image = eyeImage
        hairview.image = hairImage
        faceview.image = faceImage
        customclothes.image = clothesImage
        originalclothes = clothesImage
        
        clothesview.image = UIImage(named: "\(clothes[0]).png")
        
        //pointsLabel.text = "\(points)"
        
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).stringByAppendingPathComponent(
            "mainDatabase.sqlite")
        
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if mainDB.open(){
            let clothesRes = "SELECT Points FROM Clothes Where Name='\(clothes[0])'"
            
            let cResults:FMResultSet? = mainDB.executeQuery(clothesRes,
                withArgumentsInArray: nil)
            
            if cResults?.next() == true
            {
                clothesLabel.text = cResults?.stringForColumn("Points")
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

    @IBAction func clothesR(sender: AnyObject) {
        if(clothescount + 1  < clothestotal){
            clothescount += 1
        }
        clothesview.image = UIImage(named: "\(clothes[clothescount]).png")
        customclothes.image = UIImage(named: "\(clothes[clothescount]).png")
        
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).stringByAppendingPathComponent(
            "mainDatabase.sqlite")
        
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if mainDB.open(){
            let clothesRes = "SELECT Points FROM Clothes Where Name='\(clothes[clothescount])'"
            let check = "SELECT Purchased FROM Clothes Where Name='\(clothes[clothescount])'"
            
            let cResults:FMResultSet? = mainDB.executeQuery(clothesRes,
                withArgumentsInArray: nil)
            let checkResults:FMResultSet? = mainDB.executeQuery(check,
                                                                withArgumentsInArray: nil)
            
            if cResults?.next() == true
            {
                clothesLabel.text = cResults?.stringForColumn("Points")
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
    
    @IBAction func clothesL(sender: AnyObject) {
        if(clothescount > 0){
            clothescount -= 1
        }
        if(clothescount != -1){
        clothesview.image = UIImage(named: "\(clothes[clothescount]).png")
        customclothes.image = UIImage(named: "\(clothes[clothescount]).png")
        
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).stringByAppendingPathComponent(
            "mainDatabase.sqlite")
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if mainDB.open(){
            let clothesRes = "SELECT Points FROM Clothes Where Name='\(clothes[clothescount])'"
            let check = "SELECT Purchased FROM Clothes Where Name='\(clothes[clothescount])'"
            
            let cResults:FMResultSet? = mainDB.executeQuery(clothesRes,
                withArgumentsInArray: nil)
            let checkResults:FMResultSet? = mainDB.executeQuery(check,
                                                                withArgumentsInArray: nil)
            
            if cResults?.next() == true
            {
                clothesLabel.text = cResults?.stringForColumn("Points")
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
    @IBAction func Clothes(sender: UIButton) {
        if(clothescount == -1){
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
                    let clothesRes = "SELECT Points FROM Clothes Where Name='\(clothes[clothescount])'"
                    let cresults:FMResultSet? = mainDB.executeQuery(clothesRes,
                                                                    withArgumentsInArray: nil)
                    print("x: \(x)")
                    
                    if cresults?.next() == true {
                        let y = cresults?.stringForColumn("Points")
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
                            let query2 = "UPDATE Clothes SET Purchased=1 WHERE Name='\(clothes[clothescount])'"
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
        if segue.identifier == "fromCloth"
        {
            if let destinationVC = segue.destinationViewController as? DressingRoom2{
                destinationVC.idno = idno
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = originalclothes
                destinationVC.faceImage = faceview.image
                
            }
        }
    }
}

