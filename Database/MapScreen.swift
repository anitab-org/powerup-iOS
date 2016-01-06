//
//  MapScreen.swift
//  Database
//

import UIKit
import SpriteKit


class MapScreen: UIViewController {
    let defaults = NSUserDefaults.standardUserDefaults()
    var numberToDisplay = 0
    var timesPlayed1 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Back Button of navigation controller hidden
        self.navigationItem.setHidesBackButton(true, animated:true);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // setting the orientation to portrait
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        defaults.removeObjectForKey("timesplayed")
    }
    
    //Level 2 Button: clickable
    @IBAction func ClickableMap(sender: UIButton) {
        
        
    }
    
    // logo button on top right corner clickable
    @IBAction func logoButton(sender: UIButton) {
    }
    
    //Level 1 Button
    @IBAction func ChoicesClickableMap(sender: UIButton) {
        
        
        // Testing condition if level 1 button pressed again after coming out of the scenario
        
        if (timesPlayed1 > 0)
        {
            print("This action is not possible!! Kindly choose another level!!")
            
            //alert message popped up
            let alertView = UIAlertView();
            alertView.addButtonWithTitle("Ok");
            alertView.title = "MESSAGE!!!";
            alertView.message = "You have already played this scenario! Go try another level!!";
            
            alertView.show();
            
            
        }
            
            // condition for first time click - navigates to scenario
        else{
            timesPlayed1++
            performSegueWithIdentifier("start1View", sender: self)
            
            
        }
        
        
        
    }
    
    @IBAction func unwindToMapScreen(segue: UIStoryboardSegue) {
        /*
        var x = defaults.integerForKey("timesplayed")
        x++
        let vc = Choices_EndScreen()
        if(x == 1){
            vc.attemptsLabel.text = "This scenario was played once"
        }else{
            vc.attemptsLabel.text = "This scenario was replayed \(x) times"
        }
        */
        defaults.setInteger(0, forKey: "timesplayed")
    }
    
}