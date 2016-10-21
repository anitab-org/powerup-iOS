//
//  MapScreen.swift
//

import UIKit
import SpriteKit


class MapScreen: UIViewController {
   
    let defaults = UserDefaults.standard
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
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
    }

    //Level 2 Button: clickable
    @IBAction func ClickableMap(_ sender: UIButton) {
    
    }
    
    // logo button on top right corner clickable
    @IBAction func logoButton(_ sender: UIButton) {
    }
    
    //Level 1 Button
    @IBAction func ChoicesClickableMap(_ sender: UIButton) {
      
      // Testing condition if level 1 button pressed again after comming out of the scenario
        //if (numberToDisplay > 0)
        x = defaults.integer(forKey: "backtomap")
        if (x > 0)
        {
            print("This action is not possible!! Kindly choose another level!!")
            
           //alert message popped up
            let alert = UIAlertController(title: "MESSAGE!!!", message:"You have already played this scenario! Go try another level!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
            self.present(alert, animated: true){}
            
        }
            
            // condition for first time click - navigates to scenario
        else{
            
            performSegue(withIdentifier: "start1View", sender: self)
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "start1View"
        {
            if let destinationVC = segue.destination as? Choices_FirstScreen  {
                
              
                destinationVC.eyeImage = eyeImage
                destinationVC.hairImage = hairImage
                destinationVC.clothesImage = clothesImage
                destinationVC.faceImage = faceImage
            }
        }
        if segue.identifier == "start2View"
        {
            if let destinationVC = segue.destination as? ViewController  {
                
                destinationVC.eyeImage = eyeImage
                destinationVC.hairImage = hairImage
                destinationVC.clothesImage = clothesImage
                destinationVC.faceImage = faceImage
            }
        }
    }


}
