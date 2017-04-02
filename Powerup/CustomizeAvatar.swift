
//  CustomizeAvatar.swift

import UIKit



class CustomizeAvatar: UIViewController {
    
    var databasePath = NSString()
    @IBOutlet weak var customclothes: UIImageView!
    @IBOutlet weak var customhair: UIImageView!
    @IBOutlet weak var customface: UIImageView!
    @IBOutlet weak var customeyes: UIImageView!
    @IBOutlet weak var goHomeButton: UIButton!
    
    @IBOutlet weak var eyesview: UIImageView!
    var eyes = ["blue_eyes", "brown_eyes", "green_eyes","lightGreen_eyes","lightPink_eyes","grey_eyes","pink_eyes"]
    var eyescount = 0
    var eyestotal = 7
    @IBOutlet weak var faceview: UIImageView!
    var face = ["brick_face", "yellow_face",  "orange_face","peach_face"]
    var facecount = 0
    var facetotal = 4
    @IBOutlet weak var hairview: UIImageView!
    var hair = ["hair2", "hair3", "hair4", "hair5", "hair6", "hair7", "hair8", "hair9", "hair10", "hair11"]
    var haircount = 0
    var hairtotal = 10
    @IBOutlet weak var clothesview: UIImageView!
    var clothes = ["cloth1", "cloth2", "cloth3", "cloth4", "cloth5", "cloth6", "cloth7", "cloth8", "cloth9"]
    var clothescount = 0
    var clothestotal = 9

    override func viewDidLoad() {
        super.viewDidLoad()
        eyesview.image = UIImage(named: "\(eyes[eyescount]).png")
        hairview.image = UIImage(named: "\(hair[haircount]).png")
        clothesview.image = UIImage(named: "\(clothes[clothescount]).png")
        faceview.image = UIImage(named: "\(face[facecount]).png")
        
        customeyes.image = UIImage(named: "\(eyes[eyescount]).png")
        customclothes.image = UIImage(named: "\(clothes[clothescount]).png")
        customface.image = UIImage(named: "\(face[facecount]).png")
        customhair.image = UIImage(named: "\(hair[haircount]).png")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    @IBAction func clothesR(_ sender: AnyObject) {
        
        
        clothescount += 1
        clothescount = clothescount%clothestotal
        
        clothesview.image = UIImage(named: "\(clothes[clothescount]).png")
        customclothes.image = UIImage(named: "\(clothes[clothescount]).png")
    }
    
    @IBAction func clothesL(_ sender: AnyObject) {
     
        clothescount -= 1
        if(clothescount == -1){
            clothescount = clothestotal-1
        }
        clothesview.image = UIImage(named: "\(clothes[clothescount]).png")
        customclothes.image = UIImage(named: "\(clothes[clothescount]).png")
    }
    
    @IBAction func hairR(_ sender: AnyObject) {
        
      
        haircount += 1
        haircount = haircount%hairtotal
        
        hairview.image = UIImage(named: "\(hair[haircount]).png")
        customhair.image = UIImage(named: "\(hair[haircount]).png")
        
        
    }
    @IBAction func hairL(_ sender: AnyObject) {
        
        haircount -= 1
        if(haircount == -1){
            haircount = hairtotal-1
        }
        hairview.image = UIImage(named: "\(hair[haircount]).png")
        customhair.image = UIImage(named: "\(hair[haircount]).png")
      
    }
    @IBAction func faceR(_ sender: AnyObject) {
     
        facecount += 1
        facecount = facecount%facetotal
        
        faceview.image = UIImage(named: "\(face[facecount]).png")
        customface.image = UIImage(named: "\(face[facecount]).png")
    }
    
    @IBAction func faceL(_ sender: AnyObject) {
        
        facecount -= 1
        if(facecount == -1){
            facecount = facetotal-1
        }
        faceview.image = UIImage(named: "\(face[facecount]).png")
        customface.image = UIImage(named: "\(face[facecount]).png")
    }
    
    @IBAction func eyesR(_ sender: AnyObject) {
    
        eyescount += 1
        eyescount = eyescount%eyestotal
        
        eyesview.image = UIImage(named: "\(eyes[eyescount]).png")
        customeyes.image = UIImage(named: "\(eyes[eyescount]).png")
    }
    @IBAction func eyesL(_ sender: AnyObject) {
        
        eyescount -= 1
        if(eyescount == -1){
            eyescount = eyestotal-1
        }
        eyesview.image = UIImage(named: "\(eyes[eyescount]).png")
        customeyes.image = UIImage(named: "\(eyes[eyescount]).png")
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "firstMap"
        {
            if let destinationVC = segue.destination as? MapScreen  {
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
        }
        print("This is printed when you reach Map from DR1!")
        
        // Fetching database content via FMDB wrapper
        
        let filemgr = FileManager.default
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
        
        let docsDir = dirPaths[0] 
        var error: NSError?
        
        databasePath = (docsDir as NSString).appendingPathComponent(
            "mainDatabase.sqlite") as NSString
        
        
        if filemgr.fileExists(atPath: databasePath as String){
            print("FOUND!!!!")
            do {
                try filemgr.removeItem(atPath: databasePath as String)
            } catch let error1 as NSError {
                error = error1
            }
        }
       
        
       if let bundle_path = Bundle.main.path(forResource: "mainDatabase", ofType: "sqlite"){
            print("Bundle path:\(bundle_path)")
            print(" ")
            do {
                try filemgr.copyItem(atPath: bundle_path, toPath: databasePath as String)
                print("Success in copying from bundle to databasepath")
                print("Database path: \(databasePath)")
                print(" ")

            } catch let error1 as NSError {
                error = error1
                print("Failure 1")
                print(error?.localizedDescription)
            }
        
        
         let mainDB = FMDatabase(path: databasePath as String) 
        if (mainDB?.open())!{
            
            let query = "INSERT INTO Avatar (Face, Clothes, Hair, Eyes) VALUES ('\(face[facecount])', '\(clothes[clothescount])', '\(hair[haircount])', '\(eyes[eyescount])')"
              let addSuccess = mainDB?.executeUpdate(query, withArgumentsIn: nil)
            if(!addSuccess!){
                print("Failed to add data to Avatar Table")
            }
            else
            {
                print("Success....", terminator: "")
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
        mainDB?.close()
    
        }
}
}
