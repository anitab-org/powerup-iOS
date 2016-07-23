//
//  Clothes.swift
//  Powerup

import UIKit

class Clothes: UIViewController {

    var databasePath = NSString()
    @IBOutlet weak var clothesLabel: UILabel!
    @IBOutlet weak var clothesview: UIImageView!
    @IBOutlet weak var customclothes: UIImageView!
    
    @IBOutlet weak var eyesview: UIImageView!
    @IBOutlet weak var hairview: UIImageView!
    @IBOutlet weak var faceview: UIImageView!
    
    var eyeImage: UIImage!
    var faceImage: UIImage!
    var hairImage: UIImage!
    var clothesImage: UIImage!
    
    var clothes = ["cloth1", "cloth2", "cloth3", "cloth4", "cloth5", "cloth6", "cloth7", "cloth8", "cloth9"]
    var clothescount = 0
    var clothestotal = 9
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eyesview.image = eyeImage
        hairview.image = hairImage
        faceview.image = faceImage
        customclothes.image = clothesImage
        
        clothesview.image = UIImage(named: "\(clothes[0]).png")
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        
        databasePath = docsDir.stringByAppendingPathComponent(
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
            
        }
        mainDB.close()
    }

    @IBAction func clothesR(sender: AnyObject) {
        if(clothescount  < clothestotal){
            clothescount++
        }
        clothesview.image = UIImage(named: "\(clothes[clothescount-1]).png")
        customclothes.image = UIImage(named: "\(clothes[clothescount-1]).png")
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        
        databasePath = docsDir.stringByAppendingPathComponent(
            "mainDatabase.sqlite")
        
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if mainDB.open(){
            let clothesRes = "SELECT Points FROM Clothes Where Name='\(clothes[clothescount-1])'"
            
            let cResults:FMResultSet? = mainDB.executeQuery(clothesRes,
                withArgumentsInArray: nil)
            
            if cResults?.next() == true
            {
                clothesLabel.text = cResults?.stringForColumn("Points")
            }
            
        }
        mainDB.close()
    }
    
    @IBAction func clothesL(sender: AnyObject) {
        if(clothescount > 1){
            clothescount--
        }
        clothesview.image = UIImage(named: "\(clothes[clothescount-1]).png")
        customclothes.image = UIImage(named: "\(clothes[clothescount-1]).png")
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        
        databasePath = docsDir.stringByAppendingPathComponent(
            "mainDatabase.sqlite")
        
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if mainDB.open(){
            let clothesRes = "SELECT Points FROM Clothes Where Name='\(clothes[clothescount-1])'"
            
            let cResults:FMResultSet? = mainDB.executeQuery(clothesRes,
                withArgumentsInArray: nil)
            
            if cResults?.next() == true
            {
                clothesLabel.text = cResults?.stringForColumn("Points")
            }
            
        }
        mainDB.close()
        
    }
  
}

