//
//  Clothes.swift
//  Powerup

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


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
        
        paidLabel.isHidden = true
        paidLabel.transform = CGAffineTransform(rotationAngle: -45 * CGFloat(M_PI) / 180.0)
        eyesview.image = eyeImage
        hairview.image = hairImage
        faceview.image = faceImage
        customclothes.image = clothesImage
        originalclothes = clothesImage
        
        clothesview.image = UIImage(named: "\(clothes[0]).png")
        
        //pointsLabel.text = "\(points)"
        
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).appendingPathComponent(
            "mainDatabase.sqlite") as NSString
        
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if (mainDB?.open())!{
            let clothesRes = "SELECT Points FROM Clothes Where Name='\(clothes[0])'"
            
            let cResults:FMResultSet? = mainDB?.executeQuery(clothesRes,
                withArgumentsIn: nil)
            
            if cResults?.next() == true
            {
                clothesLabel.text = cResults?.string(forColumn: "Points")
            }
            
            let p = "SELECT Points FROM Score Where ID='\(idno)'"
            let presults:FMResultSet? = mainDB?.executeQuery(p,
                                                            withArgumentsIn: nil)
            
            if presults?.next() == true {
                pointsLabel.text = presults?.string(forColumn: "Points")
            }
        }
        mainDB?.close()
    }

    @IBAction func clothesR(_ sender: AnyObject) {
        if(clothescount + 1  < clothestotal){
            clothescount += 1
        }
        clothesview.image = UIImage(named: "\(clothes[clothescount]).png")
        customclothes.image = UIImage(named: "\(clothes[clothescount]).png")
        
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).appendingPathComponent(
            "mainDatabase.sqlite") as NSString
        
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if (mainDB?.open())!{
            let clothesRes = "SELECT Points FROM Clothes Where Name='\(clothes[clothescount])'"
            let check = "SELECT Purchased FROM Clothes Where Name='\(clothes[clothescount])'"
            
            let cResults:FMResultSet? = mainDB?.executeQuery(clothesRes,
                withArgumentsIn: nil)
            let checkResults:FMResultSet? = mainDB?.executeQuery(check,
                                                                withArgumentsIn: nil)
            
            if cResults?.next() == true
            {
                clothesLabel.text = cResults?.string(forColumn: "Points")
                if checkResults?.next() == true{
                    let x = checkResults?.string(forColumn: "Purchased")
                    let test:Int? = Int(x!)
                    if(test == 1){
                        paidLabel.isHidden = false
                    }
                    else{
                        paidLabel.isHidden = true
                    }
                }
            }
            
        }
        mainDB?.close()
    }
    
    @IBAction func clothesL(_ sender: AnyObject) {
        if(clothescount > 0){
            clothescount -= 1
        }
        if(clothescount != -1){
        clothesview.image = UIImage(named: "\(clothes[clothescount]).png")
        customclothes.image = UIImage(named: "\(clothes[clothescount]).png")
        
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).appendingPathComponent(
            "mainDatabase.sqlite") as NSString
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if (mainDB?.open())!{
            let clothesRes = "SELECT Points FROM Clothes Where Name='\(clothes[clothescount])'"
            let check = "SELECT Purchased FROM Clothes Where Name='\(clothes[clothescount])'"
            
            let cResults:FMResultSet? = mainDB?.executeQuery(clothesRes,
                withArgumentsIn: nil)
            let checkResults:FMResultSet? = mainDB?.executeQuery(check,
                                                                withArgumentsIn: nil)
            
            if cResults?.next() == true
            {
                clothesLabel.text = cResults?.string(forColumn: "Points")
                if checkResults?.next() == true{
                    let x = checkResults?.string(forColumn: "Purchased")
                    let test:Int? = Int(x!)
                    if(test == 1){
                        paidLabel.isHidden = false
                    }
                    else{
                        paidLabel.isHidden = true
                    }
                }
            }
        }
        mainDB?.close()
    }
}
    @IBAction func Clothes(_ sender: UIButton) {
        if(clothescount == -1){
            return
        }
        let filemgr = FileManager.default
        let dirPaths =
            NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                .userDomainMask, true)
        
        let docsDir = dirPaths[0]
        var error: NSError?
        
        databasePath = (docsDir as NSString).appendingPathComponent(
            "mainDatabase.sqlite") as NSString
        
        if filemgr.fileExists(atPath: databasePath as String){
            do {
                try filemgr.removeItem(atPath: databasePath as String)
            } catch let error1 as NSError {
                error = error1
            }
            
        }
        
        if let bundle_path = Bundle.main.path(forResource: "mainDatabase", ofType: "sqlite"){
            do {
                try filemgr.copyItem(atPath: bundle_path, toPath: databasePath as String)
            } catch let error1 as NSError {
                error = error1
                print("Failure")
                print(error?.localizedDescription)
            }
            
            let mainDB = FMDatabase(path: databasePath as String)
            if mainDB == nil{
                print("Error: \(mainDB?.lastErrorMessage())")
            }
            
            // opening the database and extracting content through suitable queries
            if (mainDB?.open())!{
                let p = "SELECT Points FROM Score Where ID='\(idno)'"
                let presults:FMResultSet? = mainDB?.executeQuery(p,
                                                                withArgumentsIn: nil)
                
                if presults?.next() == true {
                    print("Selected Points entry")
                    let x = presults?.string(forColumn: "Points")
                    let clothesRes = "SELECT Points FROM Clothes Where Name='\(clothes[clothescount])'"
                    let cresults:FMResultSet? = mainDB?.executeQuery(clothesRes,
                                                                    withArgumentsIn: nil)
                    print("x: \(x)")
                    
                    if cresults?.next() == true {
                        let y = cresults?.string(forColumn: "Points")
                        print("y: \(y)")
                        let a:Int? = Int(x!)
                        let b:Int? = Int(y!)
                        
                        if(a >= b )
                        {
                            paidLabel.isHidden = false
                            let query = "UPDATE Score SET Points='\(a!-b!)' WHERE ID='\(idno)'"
                            let addSuccess = mainDB?.executeUpdate(query, withArgumentsIn: nil)
                            if(!addSuccess!){
                                print("Failed to add data to Avatar Table")
                            }
                            else
                            {
                                print("Success in updating score entry", terminator: "")
                            }
                            pointsLabel.text = "\(a!-b!)"
                            let query2 = "UPDATE Clothes SET Purchased=1 WHERE Name='\(clothes[clothescount])'"
                            let success2 = mainDB?.executeUpdate(query2, withArgumentsIn: nil)
                            if(!success2!){
                                print("Failed to update Purchased Attribute")
                            }
                            else{
                                print("Success in updating purchased Attribute")
                            }
                            
                            if filemgr.fileExists(atPath: bundle_path){
                                print("About to del bundle file")
                                do {
                                    try filemgr.removeItem(atPath: bundle_path)
                                } catch let error1 as NSError {
                                    error = error1
                                }
                            }
                            
                            do {
                                try filemgr.copyItem(atPath: databasePath as String, toPath: bundle_path)
                                print("replaced bundle path contents")
                                
                            } catch let error1 as NSError {
                                error = error1
                                print("Failure 2")
                                print(error?.localizedDescription)
                            }
                        }
                        else{
                            let alert = UIAlertController(title: "MESSAGE!!!", message:"You don't have sufficient Points to buy this!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                            self.present(alert, animated: true){}
                        }
                    }
                    
                }
            }
            mainDB?.close()
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromCloth"
        {
            if let destinationVC = segue.destination as? DressingRoom2{
                destinationVC.idno = idno
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = originalclothes
                destinationVC.faceImage = faceview.image
                
            }
        }
    }
}

