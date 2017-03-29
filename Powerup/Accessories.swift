//
//  Accessories.swift
//  Powerup
//

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


class Accessories: UIViewController {

    var points = 0
    var idno = 0
    var databasePath = NSString()
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var bagsLabel: UILabel!
    @IBOutlet weak var paidbagsLabel: UILabel!
    @IBOutlet weak var glassesLabel: UILabel!
    @IBOutlet weak var paidglassesLabel: UILabel!
    @IBOutlet weak var hatsLabel: UILabel!
    @IBOutlet weak var paidhatsLabel: UILabel!
    @IBOutlet weak var necklaceLabel: UILabel!
    @IBOutlet weak var paidnecklaceLabel: UILabel!
    
    var eyeImage: UIImage!
    var faceImage: UIImage!
    var clothesImage: UIImage!
    var hairImage: UIImage!
    
    @IBOutlet weak var eyesview: UIImageView!
    @IBOutlet weak var hairview: UIImageView!
    @IBOutlet weak var faceview: UIImageView!
    @IBOutlet weak var clothesview: UIImageView!
    
    @IBOutlet weak var handbagsview: UIImageView!
    @IBOutlet weak var glassesview: UIImageView!
    @IBOutlet weak var hatsview: UIImageView!
    @IBOutlet weak var necklaceview: UIImageView!
    
    @IBOutlet weak var customhandbags: UIImageView!
    @IBOutlet weak var customglasses: UIImageView!
    @IBOutlet weak var customhats: UIImageView!
    @IBOutlet weak var customnecklace: UIImageView!
    
    var handbags = ["purse2", "purse3", "purse4", "purse1","purse5","purse6"]
    var glasses = ["glasses1", "glasses2", "glasses3"]
    var hats = ["hat1", "hat2", "hat4", "hat5","hat6"]
    var necklace = ["necklace1", "necklace2", "necklace3", "necklace4"]
    
    var necklacecount = -1, necklacetotal = 4
    var handbagscount = -1, handbagstotal = 6
    var glassescount = -1, glassestotal = 3
    var hatscount = -1, hatstotal = 5
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paidbagsLabel.isHidden = true
        paidbagsLabel.transform = CGAffineTransform(rotationAngle: -45 * CGFloat(M_PI) / 180.0)
        paidglassesLabel.isHidden = true
        paidglassesLabel.transform = CGAffineTransform(rotationAngle: -45 * CGFloat(M_PI) / 180.0)
        paidhatsLabel.isHidden = true
        paidhatsLabel.transform = CGAffineTransform(rotationAngle: -45 * CGFloat(M_PI) / 180.0)
        paidnecklaceLabel.isHidden = true
        paidnecklaceLabel.transform = CGAffineTransform(rotationAngle: -45 * CGFloat(M_PI) / 180.0)
        
        eyesview.image = eyeImage
        hairview.image = hairImage
        faceview.image = faceImage
        clothesview.image = clothesImage
        
        handbagsview.image = UIImage(named: "\(handbags[0]).png")
        glassesview.image = UIImage(named: "\(glasses[0]).png")
        hatsview.image = UIImage(named: "\(hats[0]).png")
        necklaceview.image = UIImage(named: "\(necklace[0]).png")
        
        //pointsLabel.text = "\(points)"
       
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        
        let docsDir = dirPaths[0]
        
        databasePath = (docsDir as NSString).appendingPathComponent(
            "mainDatabase.sqlite") as NSString
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if (mainDB?.open())!{
            
            let bagsRes = "SELECT Points FROM Accessories Where Name='\(handbags[0])'"
            let glassesRes = "SELECT Points FROM Accessories Where Name='\(glasses[0])'"
            let hatsRes = "SELECT Points FROM Accessories Where Name='\(hats[0])'"
            let necklaceRes = "SELECT Points FROM Accessories Where Name='\(necklace[0])'"
            
            let bResults:FMResultSet? = mainDB?.executeQuery(bagsRes,
                withArgumentsIn: nil)
            let gResults:FMResultSet? = mainDB?.executeQuery(glassesRes,
                withArgumentsIn: nil)
            let hResults:FMResultSet? = mainDB?.executeQuery(hatsRes,
                withArgumentsIn: nil)
            let nResults:FMResultSet? = mainDB?.executeQuery(necklaceRes,
                withArgumentsIn: nil)
            
            if bResults?.next() == true
            {
                bagsLabel.text = bResults?.string(forColumn: "Points")
            }
            
            if gResults?.next() == true
            {
                glassesLabel.text = gResults?.string(forColumn: "Points")
            }
            
            if hResults?.next() == true
            {
                hatsLabel.text = hResults?.string(forColumn: "Points")
            }
            
            if nResults?.next() == true
            {
                necklaceLabel.text = nResults?.string(forColumn: "Points")
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

    @IBAction func handbagsR(_ sender: AnyObject) {
        if(handbagscount + 1 < handbagstotal){
            handbagscount += 1
        }
        handbagsview.image = UIImage(named: "\(handbags[handbagscount]).png")
        customhandbags.image = UIImage(named: "\(handbags[handbagscount]).png")
       
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        
        let docsDir = dirPaths[0]
        
        databasePath = (docsDir as NSString).appendingPathComponent(
            "mainDatabase.sqlite") as NSString
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if (mainDB?.open())!{
            let bagsRes = "SELECT Points FROM Accessories Where Name='\(handbags[handbagscount])'"
            let check = "SELECT Purchased FROM Accessories Where Name='\(handbags[handbagscount])'"
            let bResults:FMResultSet? = mainDB?.executeQuery(bagsRes,
                withArgumentsIn: nil)
            let checkResults:FMResultSet? = mainDB?.executeQuery(check,
                                                            withArgumentsIn: nil)
            
            if bResults?.next() == true
            {
                bagsLabel.text = bResults?.string(forColumn: "Points")
                if checkResults?.next() == true{
                let x = checkResults?.string(forColumn: "Purchased")
                let test:Int? = Int(x!)
                    if(test == 1){
                        paidbagsLabel.isHidden = false
                    }
                    else{
                        paidbagsLabel.isHidden = true
                    }
                    
                }

            }
        }
        mainDB?.close()
        
    }
    
    @IBAction func handbagsL(_ sender: AnyObject) {
        if(handbagscount > 0){
            handbagscount -= 1
        }
        if(handbagscount != -1){
        handbagsview.image = UIImage(named: "\(handbags[handbagscount]).png")
        customhandbags.image = UIImage(named: "\(handbags[handbagscount]).png")
        
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        
        let docsDir = dirPaths[0]
        
        databasePath = (docsDir as NSString).appendingPathComponent(
            "mainDatabase.sqlite") as NSString
        
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if (mainDB?.open())!{
            let bagsRes = "SELECT Points FROM Accessories Where Name='\(handbags[handbagscount])'"
            let check = "SELECT Purchased FROM Accessories Where Name='\(handbags[handbagscount])'"
            let bResults:FMResultSet? = mainDB?.executeQuery(bagsRes,
                withArgumentsIn: nil)
            let checkResults:FMResultSet? = mainDB?.executeQuery(check,
                                                                withArgumentsIn: nil)
            if bResults?.next() == true
            {
                bagsLabel.text = bResults?.string(forColumn: "Points")
                if checkResults?.next() == true{
                    let x = checkResults?.string(forColumn: "Purchased")
                    let test:Int? = Int(x!)
                    if(test == 1){
                        paidbagsLabel.isHidden = false
                    }
                    else{
                        paidbagsLabel.isHidden = true
                    }
                }
            }
        }
        mainDB?.close()
        }
    }
    
    @IBAction func glassesR(_ sender: AnyObject) {
        
        if(glassescount + 1 < glassestotal){
            glassescount += 1
        }
        glassesview.image = UIImage(named: "\(glasses[glassescount]).png")
        customglasses.image = UIImage(named: "\(glasses[glassescount]).png")
        
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).appendingPathComponent(
            "mainDatabase.sqlite") as NSString
        
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if (mainDB?.open())!{
            let glassesRes = "SELECT Points FROM Accessories Where Name='\(glasses[glassescount])'"
            let check = "SELECT Purchased FROM Accessories Where Name='\(glasses[glassescount])'"
            let gResults:FMResultSet? = mainDB?.executeQuery(glassesRes,
                withArgumentsIn: nil)
            let checkResults:FMResultSet? = mainDB?.executeQuery(check,
                                                                withArgumentsIn: nil)

            if gResults?.next() == true
            {
                glassesLabel.text = gResults?.string(forColumn: "Points")
                if checkResults?.next() == true{
                    let x = checkResults?.string(forColumn: "Purchased")
                    let test:Int? = Int(x!)
                    if(test == 1){
                        paidglassesLabel.isHidden = false
                    }
                    else{
                        paidglassesLabel.isHidden = true
                    }
                }
            }
        }
        mainDB?.close()
        
    }
    @IBAction func glassesL(_ sender: AnyObject) {
        if(glassescount > 0){
            glassescount -= 1
        }
        if(glassescount != -1){
        glassesview.image = UIImage(named: "\(glasses[glassescount]).png")
        customglasses.image = UIImage(named: "\(glasses[glassescount]).png")
        
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).appendingPathComponent(
            "mainDatabase.sqlite") as NSString
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if (mainDB?.open())!{
            let glassesRes = "SELECT Points FROM Accessories Where Name='\(glasses[glassescount])'"
            let check = "SELECT Purchased FROM Accessories Where Name='\(glasses[glassescount])'"
            let gResults:FMResultSet? = mainDB?.executeQuery(glassesRes,
                withArgumentsIn: nil)
            let checkResults:FMResultSet? = mainDB?.executeQuery(check,
                                                                withArgumentsIn: nil)

            if gResults?.next() == true
            {
                glassesLabel.text = gResults?.string(forColumn: "Points")
                if checkResults?.next() == true{
                    let x = checkResults?.string(forColumn: "Purchased")
                    let test:Int? = Int(x!)
                    if(test == 1){
                        paidglassesLabel.isHidden = false
                    }
                    else{
                        paidglassesLabel.isHidden = true
                    }
                }
            }
        }
        mainDB?.close()
        }
    }
    @IBAction func hatsR(_ sender: AnyObject) {
        if(hatscount + 1 < hatstotal){
            hatscount += 1
        }
        hatsview.image = UIImage(named: "\(hats[hatscount]).png")
        customhats.image = UIImage(named: "\(hats[hatscount]).png")
       
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).appendingPathComponent(
            "mainDatabase.sqlite") as NSString
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if (mainDB?.open())!{
            let hatsRes = "SELECT Points FROM Accessories Where Name='\(hats[hatscount])'"
            let check = "SELECT Purchased FROM Accessories Where Name='\(hats[hatscount])'"
            let hResults:FMResultSet? = mainDB?.executeQuery(hatsRes,
                withArgumentsIn: nil)
            let checkResults:FMResultSet? = mainDB?.executeQuery(check,
                                                                withArgumentsIn: nil)

            if hResults?.next() == true
            {
                hatsLabel.text = hResults?.string(forColumn: "Points")
                if checkResults?.next() == true{
                    let x = checkResults?.string(forColumn: "Purchased")
                    let test:Int? = Int(x!)
                    if(test == 1){
                        paidhatsLabel.isHidden = false
                    }
                    else{
                        paidhatsLabel.isHidden = true
                    }
                }
            }
            
        }
        mainDB?.close()
        
    }
    
    @IBAction func hatsL(_ sender: AnyObject) {
        if(hatscount > 0){
            hatscount -= 1
        }
        if(hatscount != -1){
        hatsview.image = UIImage(named: "\(hats[hatscount]).png")
        customhats.image = UIImage(named: "\(hats[hatscount]).png")
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).appendingPathComponent(
            "mainDatabase.sqlite") as NSString
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if (mainDB?.open())!{
            let hatsRes = "SELECT Points FROM Accessories Where Name='\(hats[hatscount])'"
            let check = "SELECT Purchased FROM Accessories Where Name='\(hats[hatscount])'"
            let hResults:FMResultSet? = mainDB?.executeQuery(hatsRes,
                withArgumentsIn: nil)
            let checkResults:FMResultSet? = mainDB?.executeQuery(check,
                                                                withArgumentsIn: nil)

            if hResults?.next() == true
            {
                hatsLabel.text = hResults?.string(forColumn: "Points")
                if checkResults?.next() == true{
                    let x = checkResults?.string(forColumn: "Purchased")
                    let test:Int? = Int(x!)
                    if(test == 1){
                        paidhatsLabel.isHidden = false
                    }
                    else{
                        paidhatsLabel.isHidden = true
                    }
                }
            }
            
        }
        mainDB?.close()
    }
}
    @IBAction func necklaceR(_ sender: AnyObject) {
        if(necklacecount + 1 <  necklacetotal){
            necklacecount += 1
        }
        necklaceview.image = UIImage(named: "\(necklace[necklacecount]).png")
        customnecklace.image = UIImage(named: "\(necklace[necklacecount]).png")
        
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).appendingPathComponent(
            "mainDatabase.sqlite") as NSString
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if (mainDB?.open())!{
            let necklaceRes = "SELECT Points FROM Accessories Where Name='\(necklace[necklacecount])'"
            let check = "SELECT Purchased FROM Accessories Where Name='\(necklace[necklacecount])'"
            
            let nResults:FMResultSet? = mainDB?.executeQuery(necklaceRes,
                withArgumentsIn: nil)
            let checkResults:FMResultSet? = mainDB?.executeQuery(check,
                                                                withArgumentsIn: nil)
            if nResults?.next() == true
            {
                necklaceLabel.text = nResults?.string(forColumn: "Points")
                if checkResults?.next() == true{
                    let x = checkResults?.string(forColumn: "Purchased")
                    let test:Int? = Int(x!)
                    if(test == 1){
                        paidnecklaceLabel.isHidden = false
                    }
                    else{
                        paidnecklaceLabel.isHidden = true
                    }
                }
            }
        }
        mainDB?.close()
        
    }
    @IBAction func necklaceL(_ sender: AnyObject) {
        if(necklacecount > 0){
            necklacecount -= 1
        }
        if(necklacecount != -1){
        necklaceview.image = UIImage(named: "\(necklace[necklacecount]).png")
        customnecklace.image = UIImage(named: "\(necklace[necklacecount]).png")
        
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).appendingPathComponent(
            "mainDatabase.sqlite") as NSString
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if (mainDB?.open())!{
            let necklaceRes = "SELECT Points FROM Accessories Where Name='\(necklace[necklacecount])'"
            let check = "SELECT Purchased FROM Accessories Where Name='\(necklace[necklacecount])'"
            
            let nResults:FMResultSet? = mainDB?.executeQuery(necklaceRes,
                withArgumentsIn: nil)
            let checkResults:FMResultSet? = mainDB?.executeQuery(check,
                                                                withArgumentsIn: nil)
            if nResults?.next() == true
            {
                necklaceLabel.text = nResults?.string(forColumn: "Points")
                if checkResults?.next() == true{
                    let x = checkResults?.string(forColumn: "Purchased")
                    let test:Int? = Int(x!)
                    if(test == 1){
                        paidnecklaceLabel.isHidden = false
                    }
                    else{
                        paidnecklaceLabel.isHidden = true
                    }
                }
            }
            
        }
        mainDB?.close()
    }
}
    
    @IBAction func Bags(_ sender: UIButton) {
        if(handbagscount == -1){
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
            //print("\(bundle_path)")
            do {
                try filemgr.copyItem(atPath: bundle_path, toPath: databasePath as String)
                //print("Success!!!")
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
                let bagsRes = "SELECT Points FROM Accessories Where Name='\(handbags[handbagscount])'"
                let bresults:FMResultSet? = mainDB?.executeQuery(bagsRes,
                                                                withArgumentsIn: nil)
                print("x: \(x)")
                
                if bresults?.next() == true {
                let y = bresults?.string(forColumn: "Points")
                print("y: \(y)")
                    let a:Int? = Int(x!)
                    let b:Int? = Int(y!)
                    
                    if(a >= b )
                    {
                        paidbagsLabel.isHidden = false
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
                    let query2 = "UPDATE Accessories SET Purchased=1 WHERE Name='\(handbags[handbagscount])'"
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
    
    
    @IBAction func Glasses(_ sender: UIButton) {
        if(glassescount == -1){
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
            // print("FOUND!!!!")
            do {
                try filemgr.removeItem(atPath: databasePath as String)
            } catch let error1 as NSError {
                error = error1
            }
            
        }
        
        if let bundle_path = Bundle.main.path(forResource: "mainDatabase", ofType: "sqlite"){
            //print("\(bundle_path)")
            
            do {
                try filemgr.copyItem(atPath: bundle_path, toPath: databasePath as String)
                //print("Success!!!")
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
                    let bagsRes = "SELECT Points FROM Accessories Where Name='\(glasses[glassescount])'"
                    let bresults:FMResultSet? = mainDB?.executeQuery(bagsRes,
                                                                    withArgumentsIn: nil)
                    print("x: \(x)")
                    
                    if bresults?.next() == true {
                        let y = bresults?.string(forColumn: "Points")
                        print("y: \(y)")
                        let a:Int? = Int(x!)
                        let b:Int? = Int(y!)
                        
                        if(a >= b )
                        {
                            paidglassesLabel.isHidden = false
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
                            let query2 = "UPDATE Accessories SET Purchased=1 WHERE Name='\(glasses[glassescount])'"
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
    @IBAction func Hats(_ sender: UIButton) {
        if(hatscount == -1){
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
            // print("FOUND!!!!")
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
                    let bagsRes = "SELECT Points FROM Accessories Where Name='\(hats[hatscount])'"
                    let bresults:FMResultSet? = mainDB?.executeQuery(bagsRes,
                                                                    withArgumentsIn: nil)
                    print("x: \(x)")
                    
                    if bresults?.next() == true {
                        let y = bresults?.string(forColumn: "Points")
                        print("y: \(y)")
                        let a:Int? = Int(x!)
                        let b:Int? = Int(y!)
                        
                        if(a >= b )
                        {
                            paidhatsLabel.isHidden = false
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
                            let query2 = "UPDATE Accessories SET Purchased=1 WHERE Name='\(hats[hatscount])'"
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
    @IBAction func Necklace(_ sender: UIButton) {
        if(necklacecount == -1){
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
            // print("FOUND!!!!")
            do {
                try filemgr.removeItem(atPath: databasePath as String)
            } catch let error1 as NSError {
                error = error1
            }
            
        }
        
        if let bundle_path = Bundle.main.path(forResource: "mainDatabase", ofType: "sqlite"){
            //print("\(bundle_path)")
            
            do {
                try filemgr.copyItem(atPath: bundle_path, toPath: databasePath as String)
                //print("Success!!!")
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
                    let bagsRes = "SELECT Points FROM Accessories Where Name='\(necklace[necklacecount])'"
                    let bresults:FMResultSet? = mainDB?.executeQuery(bagsRes,
                                                                    withArgumentsIn: nil)
                    print("x: \(x)")
                    
                    if bresults?.next() == true {
                        let y = bresults?.string(forColumn: "Points")
                        print("y: \(y)")
                        let a:Int? = Int(x!)
                        let b:Int? = Int(y!)
                        
                        if(a >= b )
                        {
                            paidnecklaceLabel.isHidden = false
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
                            let query2 = "UPDATE Accessories SET Purchased=1 WHERE Name='\(necklace[necklacecount])'"
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
        if segue.identifier == "fromAccess"
        {
            if let destinationVC = segue.destination as? DressingRoom2{
                destinationVC.idno = idno
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
                
            }
        }
    }
}
