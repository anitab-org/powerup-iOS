//
//  Choices-EndScreen.swift
//  Database
//


import UIKit

class Choices_EndScreen: UIViewController {
    
    @IBOutlet weak var replay: UIButton!
    @IBOutlet weak var conclusionText: UITextView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var mapScreen: UIButton!
    @IBOutlet weak var girl: UIImageView!
    
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
        
        // Back Button of navigation controller hidden
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        
        var hover: CABasicAnimation = CABasicAnimation(keyPath: "position")
        hover.additive = true
        // fromValue and toValue will be relative instead of absolute values
        hover.fromValue = NSValue(CGPoint: CGPointZero)
        hover.toValue = NSValue(CGPoint: CGPointMake(0.0, -10.0))
        // y increases downwards on iOS
        hover.autoreverses = true
        // Animate back to normal afterwards
        hover.duration = 0.5
        // The duration for one part of the animation (0.2 up and 0.2 down)
        hover.repeatCount = .infinity
        // The number of times the animation should repeat
        girl.layer.addAnimation(hover, forKey: "myHoverAnimation")
        
        
        
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
    
    }

    
// Checking replay button functionality
    @IBAction func replayButton(sender: UIButton) {
    println("Replay Button Pressed!!!!!!!!!")
    }
    
    
    @IBAction func mapScreenButton(sender: UIButton) {
    }
    
    // Conveying End of Scenario to Map Screen so that Level 1 can't be clicked again, value of counter copied to numberToDisplay field of MapScreen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "nextView"
        {
            if let destinationVC = segue.destinationViewController as? MapScreen{
                counter++
                destinationVC.numberToDisplay = counter
            }
        }
        
    }

    
}
