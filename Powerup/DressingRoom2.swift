
//  DressingRoom2.swift


import UIKit

class DressingRoom2: UIViewController {
    
    var databasePath = NSString()
    let defaults = UserDefaults.standard
    var points = 0
    var idno = 0
    var numberToDisplay = 0
      @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var eyesview: UIImageView!
    @IBOutlet weak var hairview: UIImageView!
    @IBOutlet weak var faceview: UIImageView!
    @IBOutlet weak var clothesview: UIImageView!
    
    var eyeImage: UIImage!
    var faceImage: UIImage!
    var clothesImage: UIImage!
    var hairImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eyesview.image = eyeImage
        hairview.image = hairImage
        faceview.image = faceImage
        clothesview.image = clothesImage
        
        // Back Button of navigation controller hidden
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        // setting the orientation to portrait
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        /***********Update points label from table Score- database**********/
        //pointsLabel.text = "\(points)"
       
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
                /*
                let query = "INSERT INTO Score (Points) VALUES ('\(points)')"
                let addSuccess = mainDB.executeUpdate(query, withArgumentsInArray: nil)
                if(!addSuccess){
                    print("Failed to add data to Avatar Table")
                }
                else
                {
                    print("Success....", terminator: "")
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
 */
                
                let p = "SELECT Points FROM Score Where ID='\(idno)'"
                let presults:FMResultSet? = mainDB?.executeQuery(p,
                                                                withArgumentsIn: nil)
                
                if presults?.next() == true {
                    pointsLabel.text = presults?.string(forColumn: "Points")
                }
            }
            mainDB?.close()
        }
 
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapView"
        {
            if let destinationVC = segue.destination as? MapScreen{
                //destinationVC.numberToDisplay = numberToDisplay
                
                var x = defaults.integer(forKey: "backtomap")
                x += 1
                defaults.set(x, forKey: "backtomap")
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image                
            }
        }
        if segue.identifier == "accessoriesView"
        {
            if let destinationVC = segue.destination as? Accessories{
                destinationVC.points = points
                destinationVC.idno = idno
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
        }
        if segue.identifier == "clothesView"
        {
            if let destinationVC = segue.destination as? Clothes{
                destinationVC.points = points
                print("\(idno)")
                destinationVC.idno = idno
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
        }
        
        if segue.identifier == "hairView"
        {
            if let destinationVC = segue.destination as? Hair{
                destinationVC.points = points
                destinationVC.idno = idno
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
        }
    }
}



