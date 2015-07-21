//
//  MapScreen.swift
//  Database
//
//  Created by Sanya Jain on 22/06/15.
//  Copyright (c) 2015 Sanya Jain. All rights reserved.
//

import UIKit
import SpriteKit


class MapScreen: UIViewController {
    
    
    var numberToDisplay = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ClickableMap(sender: UIButton) {
    
    
    }
    
    @IBAction func logoButton(sender: UIButton) {
    }
    
    
    @IBAction func ChoicesClickableMap(sender: UIButton) {
      
        
        
        if (numberToDisplay > 0)
        {
            println("This action is not possible!! Kindly choose another level!!")
            
            //performSegueWithIdentifier("alertView", sender: self)
            var alertView = UIAlertView();
            alertView.addButtonWithTitle("Ok");
            alertView.title = "MESSAGE!!!";
            alertView.message = "You have already played this scenario! Go try another level!!";
            
            alertView.show();
            
            
        }
        else{
            performSegueWithIdentifier("start1View", sender: self)
            
            
        }
        
        
        /*
    //let fadeOut = SKAction.fadeOutWithDuration(1.0)
        
        let doors = SKTransition.doorwayWithDuration(1.5)
        let level1 = Choices_FirstScreen.animationDidStart("Choices_FirstScreen")
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions CurveEae()
            self., animations: <#() -> Void##() -> Void#>, completion: <#((Bool) -> Void)?##(Bool) -> Void#>)
        
*/
    }
   
}
