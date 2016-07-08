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
    //@IBOutlet weak var mapScreen: UIButton!
    
    var counter = 0
    var numberToDisplay = 0
    var sampleText = ""
    
    // Orientation- setting it to landscape
   override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.LandscapeRight.rawValue
        
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
        conclusionText!.layer.borderColor = UIColor.blackColor().CGColor
        conclusionText!.layer.cornerRadius = 5
        
        let value = UIInterfaceOrientation.LandscapeRight.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        
        // Suitable concluding remark is displayed
        println("\(sampleText)")
        if var check = conclusionText{
            conclusionText.text = "\(sampleText)"
        }
        // Points also displayed according to line of communication
        pointsLabel.text = "\(numberToDisplay)"
        //println("\(numberToDisplay)")
    }

    
// Checking replay button functionality
    @IBAction func replayButton(sender: UIButton) {
    println("Replay Button Pressed!!!!!!!!!")
    }
    
   /*
    @IBAction func mapScreenButton(sender: UIButton) {
    }
    */
    
    // Conveying End of Scenario to Map Screen so that Level 1 can't be clicked again, value of counter copied to numberToDisplay field of MapScreen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "nextView"
        {
            if let destinationVC = segue.destinationViewController as? DressingRoom2{
                counter++
                destinationVC.points = numberToDisplay
                destinationVC.numberToDisplay = counter
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
                
            }
        }
        if segue.identifier == "toFirst"
        {
            if let destinationVC = segue.destinationViewController as? Choices_FirstScreen{
                
                //counter++
                //destinationVC.points = numberToDisplay
                //destinationVC.numberToDisplay = counter
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
                
            }
        }
    }

    
}
