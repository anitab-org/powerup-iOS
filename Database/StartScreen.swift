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
    
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Start(sender: UIButton) {
        
    }

    
    @IBAction func MiniGames(sender: UIButton) {
        
            }
}
