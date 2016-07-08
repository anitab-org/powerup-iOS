//
//  MapScreen.swift
//

import UIKit
import SpriteKit


class MapScreen: UIViewController {
   
    let defaults = NSUserDefaults.standardUserDefaults()
    var eyeImage: UIImage!
    var faceImage: UIImage!
    var clothesImage: UIImage!
    var hairImage: UIImage!

    
    //var numberToDisplay = 0
    var x = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Back Button of navigation controller hidden
        self.navigationItem.setHidesBackButton(true, animated:true);

        // setting the orientation to portrait
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        
    }

    //Level 2 Button: clickable
    @IBAction func ClickableMap(sender: UIButton) {
    
    
    }
    
    // logo button on top right corner clickable
    @IBAction func logoButton(sender: UIButton) {
    }
    
    //Level 1 Button
    @IBAction func ChoicesClickableMap(sender: UIButton) {
      
      // Testing condition if level 1 button pressed again after comming out of the scenario
        //if (numberToDisplay > 0)
        x = defaults.integerForKey("backtomap")
        if (x > 0)
        {
            println("This action is not possible!! Kindly choose another level!!")
            
           //alert message popped up
            var alertView = UIAlertView();
            alertView.addButtonWithTitle("Ok");
            alertView.title = "MESSAGE!!!";
            alertView.message = "You have already played this scenario! Go try another level!!";
            
            alertView.show();
        }
            
            // condition for first time click - navigates to scenario
        else{
            
            performSegueWithIdentifier("start1View", sender: self)
        }
       
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "start1View"
        {
            if let destinationVC = segue.destinationViewController as? Choices_FirstScreen  {
                
                destinationVC.eyeImage = eyeImage
                destinationVC.hairImage = hairImage
                destinationVC.clothesImage = clothesImage
                destinationVC.faceImage = faceImage
            }
        }
        if segue.identifier == "start2View"
        {
            if let destinationVC = segue.destinationViewController as? ViewController  {
                
                destinationVC.eyeImage = eyeImage
                destinationVC.hairImage = hairImage
                destinationVC.clothesImage = clothesImage
                destinationVC.faceImage = faceImage
            }
        }
    }


}
