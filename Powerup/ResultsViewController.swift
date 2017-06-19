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
    // Configures the accessories of the avatar.
    func configureAvatar() {
        let avatar = DatabaseAccessor.sharedInstance.getAvatar()
        
        clothesView.image = avatar.clothes.image
        faceView.image = avatar.face.image
        hairView.image = avatar.hair.image
        eyesView.image = avatar.eyes.image
        handbagView.image = avatar.handbag?.image
        glassesView.image = avatar.glasses?.image
        hatView.image = avatar.hat?.image
        necklaceView.image = avatar.necklace?.image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAvatar()
    }
}
