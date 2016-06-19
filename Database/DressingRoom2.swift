
//  DressingRoom2.swift


import UIKit

class DressingRoom2: UIViewController {
    
    var points = 0
    var numberToDisplay = 0
      @IBOutlet weak var pointsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Back Button of navigation controller hidden
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        // setting the orientation to portrait
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        pointsLabel.text = "\(points)"
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mapView"
        {
            if let destinationVC = segue.destinationViewController as? MapScreen{
                destinationVC.numberToDisplay = numberToDisplay
                
            }
        }
        
    }
}



