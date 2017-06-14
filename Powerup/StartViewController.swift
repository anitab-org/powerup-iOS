import UIKit

class StartViewController: UIViewController {
    
    // MARK: Views
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var PowerUp: UITextView!
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Actions
    @IBAction func Start(_ sender: UIButton) {
        
        // Check whether an avatar is created or not.
        if DatabaseAccessor.sharedInstance().avatarExists() {
            performSegue(withIdentifier: "toMapView", sender: self)
        } else {
            // Remind players to create an avatar first.
            let alert = UIAlertController(title: "Warning", message: "You should create a new avatar first!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func newAvatarButtonTouched(_ sender: UIButton) {
        // If previous avatar exists, warns the player that previous data will be lost.
        if DatabaseAccessor.sharedInstance().avatarExists() {
            let alert = UIAlertController(title: "Warning", message: "Sure you want to create a new avatar? Previous data will be lost!", preferredStyle: .alert)
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
