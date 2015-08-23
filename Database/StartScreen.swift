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

   // For orientation - set to Portrait
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

   // Start button is clickable
    @IBAction func Start(sender: UIButton) {
        
    }

    // minigames not clickable
    @IBAction func MiniGames(sender: UIButton) {
        
            }
    
    
    
}
