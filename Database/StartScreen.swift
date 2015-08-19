//
//  StartScreen.swift
//  Database
//
//  Created by Sanya Jain on 22/06/15.
//  Copyright (c) 2015 Sanya Jain. All rights reserved.
//

import UIKit

class StartScreen: UIViewController {
    
    
    @IBOutlet weak var MiniGamesButton: UIButton!
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var PowerUp: UITextView!
    
    var counter = -1

    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    @IBAction func Start(sender: UIButton) {
        
    }

    
    @IBAction func MiniGames(sender: UIButton) {
        
            }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "logoToStart"
        {
            if let destinationVC = segue.destinationViewController as? MapScreen{
                counter = 1
                destinationVC.numberToDisplay = counter
            }
        }

        if segue.identifier == "startToMap"
        {
            if let destinationVC = segue.destinationViewController as? MapScreen{
                counter++
                destinationVC.numberToDisplay = counter
            }
        }
        
    }

    
    
}
