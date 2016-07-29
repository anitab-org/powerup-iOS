//
//  Hair.swift
//  Powerup

import UIKit

class Hair: UIViewController {
    
    var databasePath = NSString()
    @IBOutlet weak var hairLabel: UILabel!
    @IBOutlet weak var paidLabel: UILabel!
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
        
        hairview.image = UIImage(named: "\(hair[0]).png")
        
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
    
}




