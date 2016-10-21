
//  Choices-SixthScreen.swift



import UIKit

class Choices_SixthScreen: UIViewController {

    var eyeImage: UIImage!
    var faceImage: UIImage!
    var clothesImage: UIImage!
    var hairImage: UIImage!
    
    
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    
    @IBOutlet weak var continueImage: UIImageView!
    @IBOutlet weak var continueToEnd: UIButton!
        var databasePath = NSString()
        var points = 20
        var passString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Back Button of navigation controller hidden
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        // Setting the label's border and making its corners rounded
        labelView!.layer.borderWidth = 6
        labelView!.layer.borderColor = UIColor.black.cgColor
        labelView!.layer.cornerRadius = 5
        
        // Making content in the label to be word wrapped(and not in center)
        labelView.lineBreakMode = .byWordWrapping
        labelView.numberOfLines = 0
        
        // Accessing the database
       
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
            .userDomainMask, true)
    
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).appendingPathComponent(
            "Choices.sqlite") as NSString
        
        let mainDB = FMDatabase(path: databasePath as String)
        
        if (mainDB?.open())!{
            let comment1 = "SELECT Text FROM Communication WHERE QID='F' AND AID='$'"
            let comment2 = "SELECT Text FROM Communication WHERE QID='H' AND AID='$'"
            
            let c1results:FMResultSet? = mainDB?.executeQuery(comment1,
                withArgumentsIn: nil)
            let c2results:FMResultSet? = mainDB?.executeQuery(comment2,
                withArgumentsIn: nil)
            
            if c1results?.next() == true {
                labelView.text = c1results?.string(forColumn: "Text")
                
            }
            
            if c2results?.next() == true {
                let a = c2results?.string(forColumn: "Text")
                passString = passString + a!
            }

        }
    
    }

    @IBAction func continueButton(_ sender: UIButton) {
    }
    
    // Communicate to ending screen that assertive mode of communication was chosen so that appropriate concluding mark can be displayed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "assertive"
        {
            if let destinationVC = segue.destination as? Choices_EndScreen{
                
                destinationVC.sampleText = passString
                print("\(passString)")
                destinationVC.numberToDisplay = points
                
                destinationVC.eyeImage = eyeImage
                destinationVC.hairImage = hairImage
                destinationVC.clothesImage = clothesImage
                destinationVC.faceImage = faceImage
            }
        }
    }
}

    


