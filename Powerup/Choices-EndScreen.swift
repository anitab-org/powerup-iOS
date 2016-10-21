//
//  Choices-EndScreen.swift



import UIKit

class Choices_EndScreen: UIViewController {
    
    @IBOutlet weak var eyesview: UIImageView!
    @IBOutlet weak var hairview: UIImageView!
    @IBOutlet weak var faceview: UIImageView!
    @IBOutlet weak var clothesview: UIImageView!
    
    var eyeImage: UIImage!
    var faceImage: UIImage!
    var clothesImage: UIImage!
    var hairImage: UIImage!
    
    @IBOutlet weak var replay: UIButton!
    @IBOutlet weak var conclusionText: UITextView!
    @IBOutlet weak var pointsLabel: UILabel!
    
    var counter = 0
    var numberToDisplay = 0
    var sampleText = ""
    
    // Orientation- setting it to landscape
   override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [.portrait]
        //return UIInterfaceOrientation.LandscapeRight.rawValue
        
    }
    
      override func viewDidLoad() {
        super.viewDidLoad()
        
        eyesview.image = eyeImage
        hairview.image = hairImage
        faceview.image = faceImage
        clothesview.image = clothesImage
        
        // Back Button of navigation controller hidden
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        // TextView borders and rounded corners
        conclusionText!.layer.borderWidth = 6
        conclusionText!.layer.borderColor = UIColor.black.cgColor
        conclusionText!.layer.cornerRadius = 5
        
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        
        // Suitable concluding remark is displayed
        if conclusionText != nil{
            conclusionText.text = "\(sampleText)"
        }
        // Points also displayed according to line of communication
        pointsLabel.text = "\(numberToDisplay)"
    }

    
// Checking replay button functionality
    @IBAction func replayButton(_ sender: UIButton) {
    print("Replay Button Pressed...")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextView"
        {
            if let destinationVC = segue.destination as? DressingRoom2{
                
                destinationVC.points = numberToDisplay
                
                if(numberToDisplay == 0){
                    destinationVC.idno = 1
                }
                else if(numberToDisplay == 10){
                    destinationVC.idno = 2
                }
                else if(numberToDisplay == 20){
                    destinationVC.idno = 3
                }
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
                
            }
        }
        if segue.identifier == "toFirst"
        {
            if let destinationVC = segue.destination as? Choices_FirstScreen{
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
                
            }
        }
    }

    
}
