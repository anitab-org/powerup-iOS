import UIKit

class StartViewController: UIViewController, SegueHandlerType {
    enum SegueIdentifier: String {
        case toMapView = "toMapView"
        case toNewAvatar = "toNewAvatar"
    }
    
    // MARK: Properties
    var dataSource: DataSource = DatabaseAccessor.sharedInstance
    
    // MARK: Views
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var PowerUp: UITextView!
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if the database is initialized yet. If no, initialize it.
        if !dataSource.databaseIsInitialized() {
            do {
                try dataSource.initializeDatabase()
            } catch _ {
                let alert = UIAlertController(title: "Warning", message: "Error initializing user data, please restart the app.", preferredStyle: .alert)
                
                // Quit app when ok button is clicked.
                let okButton = UIAlertAction(title: "OK", style: .destructive, handler: {action in exit(1)})
                
                alert.addAction(okButton)
                self.present(alert, animated: true)
            }
        }
    }
    
    // MARK: Actions
    @IBAction func Start(_ sender: UIButton) {
        
        // Check whether an avatar is created or not.
        if dataSource.avatarExists() {
            performSegueWithIdentifier(.toMapView, sender: self)
        } else {
            // Remind players to create an avatar first.
            let alert = UIAlertController(title: "Warning", message: "Create your avatar to start the game!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                self.performSegueWithIdentifier(.toNewAvatar, sender: self)
                }))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func newAvatarButtonTouched(_ sender: UIButton) {
        // If previous avatar exists, warns the player that previous data will be lost.
        if dataSource.avatarExists() {
            let alert = UIAlertController(title: "Are you sure?", message: "If you start a new game, previous data and all Karma points will be lost!", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Create New Avatar", style: .destructive, handler: {(action) -> Void in self.performSegueWithIdentifier(.toNewAvatar, sender: self)})
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(okButton)
            alert.addAction(cancelButton)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            performSegueWithIdentifier(.toNewAvatar, sender: self)
        }
        // Re-shows tutorial, when creating a new avatar
        UserDefaults.setTutorialViewed(key: .MineSweeperTutorialViewed, value: false)
        UserDefaults.setTutorialViewed(key: .VocabTutorialViewed, value: false)
        UserDefaults.setTutorialViewed(key: .SinkToSwimTutorialViewed, value: false)
        
    }
    
    
    
    // MARK: Segues
    @IBAction func unwindToStart(unwindSegue: UIStoryboardSegue) {
        
    }
    
    
}
