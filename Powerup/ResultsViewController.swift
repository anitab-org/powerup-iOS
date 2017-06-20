import UIKit

class ResultsViewController: UIViewController {
    
    // TODO: Should detemine how many Karma points will be given after each completion of scenario.
    let karmaGain = 20
    
    // MARK: Views
    @IBOutlet weak var eyesView: UIImageView!
    @IBOutlet weak var hairView: UIImageView!
    @IBOutlet weak var faceView: UIImageView!
    @IBOutlet weak var clothesView: UIImageView!
    @IBOutlet weak var necklaceView: UIImageView!
    @IBOutlet weak var handbagView: UIImageView!
    @IBOutlet weak var glassesView: UIImageView!
    @IBOutlet weak var hatView: UIImageView!
    @IBOutlet weak var karmaPointsLabel: UILabel!
    
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
        
        // Save the karma gains in database.
        let newScore = DatabaseAccessor.sharedInstance.getScore() + Score(karmaPoints: karmaGain)
        guard DatabaseAccessor.sharedInstance.saveScore(score: newScore) else {
            print("Error saving karma points to database.")
            return
        }
        
        // Update karma points label.
        karmaPointsLabel.text = String(newScore.karmaPoints)
        
        // Notify the players of the karma gain with a pop-up.
        let notification = UIAlertController(title: "Hooray!", message: "You gained \(karmaGain) Karma points!", preferredStyle: .alert)
        notification.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(notification, animated: true, completion: nil)
        
        // TODO: Save the completion of scenarios in the database.
        
    }
}
