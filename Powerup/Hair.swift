//
//  Hair.swift
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
        
        paidLabel.isHidden = true
        paidLabel.transform = CGAffineTransform(rotationAngle: -45 * CGFloat(M_PI) / 180.0)
        eyesview.image = eyeImage
        clothesview.image = clothesImage
        faceview.image = faceImage
        customhair.image = hairImage
        originalhair = hairImage
        hairview.image = UIImage(named: "\(hair[0]).png")
        
        //pointsLabel.text = "\(points)"
        
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).appendingPathComponent(
            "mainDatabase.sqlite") as NSString
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if (mainDB?.open())!{
            let hairRes = "SELECT Points FROM Hair Where Name='\(hair[0])'"
            
            let hResults:FMResultSet? = mainDB?.executeQuery(hairRes,
                withArgumentsIn: nil)
            
            if hResults?.next() == true
            {
                hairLabel.text = hResults?.string(forColumn: "Points")
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
    
    @IBAction func hairR(_ sender: AnyObject) {
        if(haircount + 1 < hairtotal){
            haircount += 1
        }
        hairview.image = UIImage(named: "\(hair[haircount]).png")
        customhair.image = UIImage(named: "\(hair[haircount]).png")
       
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).appendingPathComponent(
            "mainDatabase.sqlite") as NSString
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if (mainDB?.open())!{
            let hairRes = "SELECT Points FROM Hair Where Name='\(hair[haircount])'"
            let check = "SELECT Purchased FROM Hair Where Name='\(hair[haircount])'"
            
            let hResults:FMResultSet? = mainDB?.executeQuery(hairRes,
                                                            withArgumentsIn: nil)
            let checkResults:FMResultSet? = mainDB?.executeQuery(check,
                                                                withArgumentsIn: nil)
            if hResults?.next() == true
            {
                hairLabel.text = hResults?.string(forColumn: "Points")
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
    
    @IBAction func hairL(_ sender: AnyObject) {
        if(haircount > 0){
            haircount -= 1
        }
        if(haircount != -1){
        hairview.image = UIImage(named: "\(hair[haircount]).png")
        customhair.image = UIImage(named: "\(hair[haircount]).png")
        
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).appendingPathComponent(
            "mainDatabase.sqlite") as NSString
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if (mainDB?.open())!{
            let hairRes = "SELECT Points FROM Hair Where Name='\(hair[haircount])'"
            let check = "SELECT Purchased FROM Hair Where Name='\(hair[haircount])'"
            
            let hResults:FMResultSet? = mainDB?.executeQuery(hairRes,
                withArgumentsIn: nil)
            let checkResults:FMResultSet? = mainDB?.executeQuery(check,
                                                                withArgumentsIn: nil)
            
            if hResults?.next() == true
            {
                hairLabel.text = hResults?.string(forColumn: "Points")
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
    
    @IBAction func Hair(_ sender: UIButton) {
        if(haircount == -1){
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
                    let hairRes = "SELECT Points FROM Hair Where Name='\(hair[haircount])'"
                    let hresults:FMResultSet? = mainDB?.executeQuery(hairRes,
                                                                    withArgumentsIn: nil)
                    print("x: \(x)")
                    
                    if hresults?.next() == true {
                        let y = hresults?.string(forColumn: "Points")
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
                            let query2 = "UPDATE Hair SET Purchased=1 WHERE Name='\(hair[haircount])'"
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
        if segue.identifier == "fromHair"
        {
            if let destinationVC = segue.destination as? DressingRoom2{
                destinationVC.idno = idno
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = originalhair
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
                
            }
        }
    }
}




