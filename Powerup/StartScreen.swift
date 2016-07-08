//
//  StartScreen.swift
//


import UIKit

class StartScreen: UIViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var MiniGamesButton: UIButton!
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var PowerUp: UITextView!
    
    
    var counter = -1

   // For orientation - set to Portrait
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
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
   
    @IBAction func NewUser(sender: UIButton) {
        var x = defaults.integerForKey("backtomap")
        x = 0
        defaults.setInteger(x, forKey: "backtomap")
        
    }
    
    
}
