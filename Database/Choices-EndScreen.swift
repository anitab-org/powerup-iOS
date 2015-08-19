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
    
    var counter = 0
    var numberToDisplay = 0
    var sampleText = ""
    
    
   override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.LandscapeRight.rawValue
        
    }
    
    
      override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        conclusionText!.layer.borderWidth = 6
        conclusionText!.layer.borderColor = UIColor.blackColor().CGColor
        conclusionText!.layer.cornerRadius = 5
        
        let value = UIInterfaceOrientation.LandscapeRight.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        println("\(sampleText)")
        if var check = conclusionText{
            conclusionText.text = "\(sampleText)"
        }
        pointsLabel.text = "\(numberToDisplay)"
    
    }

    

    @IBAction func replayButton(sender: UIButton) {
    println("Replay Button Pressed!!!!!!!!!")
    }
    
    
    @IBAction func mapScreenButton(sender: UIButton) {
    }
    
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
