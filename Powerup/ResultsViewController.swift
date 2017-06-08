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
    func configureAvatar() {
        let avatarConfig = DatabaseAccessor.sharedInstance().getAvatar()
        clothesView.image = UIImage(named: avatarConfig["Clothes"]!.1)
        faceView.image = UIImage(named: avatarConfig["Face"]!.1)
        hairView.image = UIImage(named: avatarConfig["Hair"]!.1)
        eyesView.image = UIImage(named: avatarConfig["Eyes"]!.1)
        
        // Optional accessories
        if let handbagName = avatarConfig["Handbag"]?.1 {
            handbagView.image = UIImage(named: handbagName)
        } else {
            handbagView.isHidden = true
        }
        
        if let glassesName = avatarConfig["Glasses"]?.1 {
            glassesView.image = UIImage(named: glassesName)
        } else {
            glassesView.isHidden = true
        }
        
        if let necklaceName = avatarConfig["Necklace"]?.1 {
            necklaceView.image = UIImage(named: necklaceName)
        } else {
            necklaceView.isHidden = true
        }
        
        if let hatName = avatarConfig["Hat"]?.1 {
            hatView.image = UIImage(named: hatName)
        } else {
            hatView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAvatar()
    }
}
