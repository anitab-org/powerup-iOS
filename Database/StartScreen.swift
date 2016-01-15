//
//  StartScreen.swift
//  Database
//


import UIKit

class StartScreen: UIViewController {
    
    
    @IBOutlet weak var MiniGamesButton: UIButton!
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var PowerUp: UITextView!
    
    var counter = -1

   // For orientation - set to any
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    
    override func supportedInterfaceOrientations() -> Int {
         return UIInterfaceOrientation.Portrait.rawValue | UIInterfaceOrientation.LandscapeLeft.rawValue | UIInterfaceOrientation.LandscapeRight.rawValue
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Back Button of navigation controller is hidden on home screen
        self.navigationItem.setHidesBackButton(true, animated:true);
    
    }

   // Start button is clickable
    @IBAction func Start(sender: UIButton) {
        
    }

    // minigames not clickable
    @IBAction func MiniGames(sender: UIButton) {
        
    }
    
    
    
}
