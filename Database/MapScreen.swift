//
//  MapScreen.swift
//  Database
//

import UIKit
import SpriteKit


class MapScreen: UIViewController {
    
    
    var numberToDisplay = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true);

        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        
    }

       @IBAction func ClickableMap(sender: UIButton) {
    
    
    }
    
    @IBAction func logoButton(sender: UIButton) {
    }
    
    
    @IBAction func ChoicesClickableMap(sender: UIButton) {
      
        
        
        if (numberToDisplay > 0)
        {
            println("This action is not possible!! Kindly choose another level!!")
            
            var alertView = UIAlertView();
            alertView.addButtonWithTitle("Ok");
            alertView.title = "MESSAGE!!!";
            alertView.message = "You have already played this scenario! Go try another level!!";
            
            alertView.show();
            
            
        }
        else{
            
            performSegueWithIdentifier("start1View", sender: self)
            
            
        }
        
        
       
    }
   
}
