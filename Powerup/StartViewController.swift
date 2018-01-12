import UIKit

class StartViewController: UIViewController {
    
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
            performSegue(withIdentifier: "toMapView", sender: self)
        } else {
            // Remind players to create an avatar first.
            let alert = UIAlertController(title: "Warning", message: "Create your avatar to start the game!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                self.performSegue(withIdentifier: "toNewAvatar", sender: self)
            }))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func newAvatarButtonTouched(_ sender: UIButton) {
        // Allow the mini game tutorials to be shown for the first time
        UserDefaults.standard.set(false, forKey: "MineTutsViewed")
        UserDefaults.standard.set(false, forKey: "VocabTutsViewed")
        UserDefaults.standard.set(false, forKey: "SwimTutsViewed")
        // If previous avatar exists, warns the player that previous data will be lost.
        if dataSource.avatarExists() {
            let alert = UIAlertController(title: "Are you sure?", message: "If you start a new game, previous data and all Karma points will be lost!", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Create New Avatar", style: .destructive, handler: {(action) -> Void in self.performSegue(withIdentifier: "toNewAvatar", sender: self)})
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(okButton)
            alert.addAction(cancelButton)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "toNewAvatar", sender: self)
        }
        
    }
    
    
    
    // MARK: Segues
    @IBAction func unwindToStart(unwindSegue: UIStoryboardSegue) {
        
    }
    
    
}
