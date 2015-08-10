//
//  Choices-EndScreen.swift
//  Database
//


import UIKit

class Choices_EndScreen: UIViewController {
    
    @IBOutlet weak var replay: UIButton!
    
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var mapScreen: UIButton!
    
    var counter = 0
    var numberToDisplay = 0
    //var isPresented = true
    
    
   override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.LandscapeRight.rawValue
        //return UIInterfaceOrientation.LandscapeLeft.rawValue
    }
    
    
    
    /*@IBAction
    func dismiss() {
        
        isPresented = false
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil);
        
    }*/

    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.LandscapeRight.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        

   
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
