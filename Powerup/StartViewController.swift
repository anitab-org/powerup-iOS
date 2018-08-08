import UIKit

class StartViewController: UIViewController, SegueHandler {
    enum SegueIdentifier: String {
        case toMapView = "toMapView"
        case toNewAvatarView = "toNewAvatar"
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
                let alert = UIAlertController(title: warningTitleMessage, message: errorRestartAppMessage, preferredStyle: .alert)

                // Quit app when ok button is clicked.
                let okButton = UIAlertAction(title: okText, style: .destructive, handler: { action in exit(1) })

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

            let alert = UIAlertController(title: warningTitleMessage, message: createAvatarMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: okText, style: .default, handler: { action in
                self.performSegueWithIdentifier(.toNewAvatarView, sender: self)
            }))

            self.present(alert, animated: true)
        }
    }

    @IBAction func newAvatarButtonTouched(_ sender: UIButton) {
        // If previous avatar exists, warns the player that previous data will be lost.
        if dataSource.avatarExists() {
            let alert = UIAlertController(title: confirmationTitleMessage, message: startNewGameMessage, preferredStyle: .alert)
            let okButton = UIAlertAction(title: newAvatarTitleMessage, style: .destructive, handler: { (action) -> Void in self.performSegueWithIdentifier(.toNewAvatarView, sender: self) })
            let cancelButton = UIAlertAction(title: cancelText, style: .cancel)
            alert.addAction(okButton)
            alert.addAction(cancelButton)
            self.present(alert, animated: true, completion: nil)
        } else {
            performSegueWithIdentifier(.toNewAvatarView, sender: self)
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
