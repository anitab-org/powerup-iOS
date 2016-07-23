//
//  Hair.swift
//  Powerup

import UIKit

class Hair: UIViewController {
    
    var databasePath = NSString()
    @IBOutlet weak var hairLabel: UILabel!
    @IBOutlet weak var hairview: UIImageView!
    @IBOutlet weak var customhair: UIImageView!
    
    @IBOutlet weak var eyesview: UIImageView!
    @IBOutlet weak var clothesview: UIImageView!
    @IBOutlet weak var faceview: UIImageView!
    
    var eyeImage: UIImage!
    var faceImage: UIImage!
    var hairImage: UIImage!
    var clothesImage: UIImage!
    
    var hair = ["hair2", "hair3", "hair4", "hair5", "hair6", "hair7", "hair8", "hair9", "hair10", "hair11"]
    var haircount = 0
    var hairtotal = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eyesview.image = eyeImage
        clothesview.image = clothesImage
        faceview.image = faceImage
        customhair.image = hairImage
        
        hairview.image = UIImage(named: "\(hair[0]).png")
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        
        databasePath = docsDir.stringByAppendingPathComponent(
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
            
        }
        mainDB.close()
        
    }
    
    @IBAction func hairR(sender: AnyObject) {
        if(haircount  < hairtotal){
            haircount++
        }
        hairview.image = UIImage(named: "\(hair[haircount-1]).png")
        customhair.image = UIImage(named: "\(hair[haircount-1]).png")
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        
        databasePath = docsDir.stringByAppendingPathComponent(
            "mainDatabase.sqlite")
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if mainDB.open(){
            let hairRes = "SELECT Points FROM Hair Where Name='\(hair[haircount-1])'"
            
            let hResults:FMResultSet? = mainDB.executeQuery(hairRes,
                withArgumentsInArray: nil)
            
            if hResults?.next() == true
            {
                hairLabel.text = hResults?.stringForColumn("Points")
            }
            
        }
        mainDB.close()
    }
    
    @IBAction func hairL(sender: AnyObject) {
        if(haircount > 1){
            haircount--
        }
        hairview.image = UIImage(named: "\(hair[haircount-1]).png")
        customhair.image = UIImage(named: "\(hair[haircount-1]).png")
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        
        databasePath = docsDir.stringByAppendingPathComponent(
            "mainDatabase.sqlite")
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if mainDB.open(){
            let hairRes = "SELECT Points FROM Hair Where Name='\(hair[haircount-1])'"
            
            let hResults:FMResultSet? = mainDB.executeQuery(hairRes,
                withArgumentsInArray: nil)
            
            if hResults?.next() == true
            {
                hairLabel.text = hResults?.stringForColumn("Points")
            }
            
        }
        mainDB.close()
        
    }
    
}




