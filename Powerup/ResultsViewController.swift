import UIKit

class ResultsViewController: UIViewController {
    
    // MARK: Views
    @IBOutlet weak var eyesView: UIImageView!
    @IBOutlet weak var hairView: UIImageView!
    @IBOutlet weak var faceView: UIImageView!
    @IBOutlet weak var clothesView: UIImageView!
    @IBOutlet weak var necklaceView: UIImageView!
    @IBOutlet weak var handbagView: UIImageView!
    @IBOutlet weak var glassesView: UIImageView!
    @IBOutlet weak var hatView: UIImageView!
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the appearence of the avatar
        Customizables.applyCustomizables(clothes: clothesView, face: faceView, hair: hairView, eyes: eyesView, handBag: handbagView, glasses: glassesView, necklace: necklaceView, hat: hatView)
    }
}
