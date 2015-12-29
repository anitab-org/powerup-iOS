//
//  Choices-EndScreen.swift
//  Database
//


import UIKit

class Choices_EndScreen: UIViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var replay: UIButton!
    @IBOutlet weak var conclusionText: UITextView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var mapScreen: UIButton!
    
    var counter = 0
    var numberToDisplay = 0
    var sampleText = ""
    
    // Orientation- setting it to landscape
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Back Button of navigation controller hidden
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        // TextView borders and rounded corners
        conclusionText!.layer.borderWidth = 6
        conclusionText!.layer.borderColor = UIColor.blackColor().CGColor
        conclusionText!.layer.cornerRadius = 5
        
        let value = UIInterfaceOrientation.LandscapeRight.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        
        // Suitable concluding remark is displayed
        print("\(sampleText)")
        if var check = conclusionText{
            conclusionText.text = "\(sampleText)"
        }
        // Points also displayed according to line of communication
        pointsLabel.text = "\(numberToDisplay)"
        
    }
    
    
    // Checking replay button functionality
    @IBAction func replayButton(sender: UIButton) {
        print("Replay Button Pressed!!!!!!!!!")
    }
    
    
    @IBAction func mapScreenButton(sender: UIButton) {
    }
    
    // Conveying End of Scenario to Map Screen so that Level 1 can't be clicked again, value of counter copied to numberToDisplay field of MapScreen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "nextView"
        {
            if let destinationVC = segue.destinationViewController as? MapScreen{
                counter = defaults.integerForKey("level1clicks")
                counter++
                defaults.setInteger(counter, forKey: "level1clicks")
            }
        }
        
    }
    
    
}
