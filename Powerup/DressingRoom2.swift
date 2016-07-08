
//  DressingRoom2.swift


import UIKit

class DressingRoom2: UIViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var points = 0
    var numberToDisplay = 0
      @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var eyesview: UIImageView!
    @IBOutlet weak var hairview: UIImageView!
    @IBOutlet weak var faceview: UIImageView!
    @IBOutlet weak var clothesview: UIImageView!
    
    var eyeImage: UIImage!
    var faceImage: UIImage!
    var clothesImage: UIImage!
    var hairImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eyesview.image = eyeImage
        hairview.image = hairImage
        faceview.image = faceImage
        clothesview.image = clothesImage
        
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
                //destinationVC.numberToDisplay = numberToDisplay
                
                var x = defaults.integerForKey("backtomap")
                x++
                defaults.setInteger(x, forKey: "backtomap")
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image                
            }
        }
        if segue.identifier == "accessoriesView"
        {
            if let destinationVC = segue.destinationViewController as? Accessories{
                destinationVC.points = points
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
        }
        if segue.identifier == "clothesView"
        {
            if let destinationVC = segue.destinationViewController as? Clothes{
                //destinationVC.points = points
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
        }
        
        if segue.identifier == "hairView"
        {
            if let destinationVC = segue.destinationViewController as? Hair{
                //destinationVC.points = points
                
                destinationVC.eyeImage = eyesview.image
                destinationVC.hairImage = hairview.image
                destinationVC.clothesImage = clothesview.image
                destinationVC.faceImage = faceview.image
            }
        }
    }
}



