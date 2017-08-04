import UIKit

class ResultsViewController: UIViewController {
    
    // TODO: Should detemine how many Karma points will be given after each completion of scenario.
    let karmaGain = 20
    
    // MARK: Properties
    // This will be set in the ScenarioViewController.
    var completedScenarioID: Int = -1
    
    // The background image. being set by either mini game view or scenario view.
    var backgroundImage: UIImage? = nil

    var dataSource: DataSource = DatabaseAccessor.sharedInstance
    
    // MARK: Views
    @IBOutlet weak var backgroundImageView: UIImageView!
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
        let avatar: Avatar!
        
        do {
            avatar = try dataSource.getAvatar()
        } catch _ {
            // Cannot load customized avatar, just use the default one.
            avatar = Avatar()
        }
        
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
        
        // Configure background image.
        backgroundImageView.image = backgroundImage
        
        configureAvatar()
        
        gainKarmaPoints()
        
        saveScenarioAndUnlockNextScenario()
    }
    

    func gainKarmaPoints() {
        // Save the karma gains in database.
        let newScore: Score!
        do {
            newScore = try dataSource.getScore() + Score(karmaPoints: karmaGain)
            try dataSource.saveScore(score: newScore)
        } catch _ {
            // If the saving failed, show an alert dialogue.
            let alert = UIAlertController(title: "Warning", message: "Error saving Karma points.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // Update karma points label.
        karmaPointsLabel.text = String(newScore.karmaPoints)
        
        // Notify the players of the karma gain with a pop-up.
        let notification = UIAlertController(title: "Hooray!", message: "You gained \(karmaGain) Karma points!", preferredStyle: .alert)
        notification.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(notification, animated: true, completion: nil)
    }
    
    func saveScenarioAndUnlockNextScenario() {
        do {
            // Get the current scenario.
            var currScenario = try dataSource.getScenario(of: completedScenarioID)
            
            currScenario.completed = true
            
            // Save the updated scenario back to database.
            try dataSource.saveScenario(currScenario)
            
            // Get the next scenario.
            var nextScenario = try dataSource.getScenario(of: currScenario.nextScenarioID)

            nextScenario.unlocked = true
            
            // Save the updated (next) scenario back to database.
            try dataSource.saveScenario(nextScenario)
            
        } catch _ {
            let alert = UIAlertController(title: "Warning", message: "Error saving scenario completion.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
    }
}
