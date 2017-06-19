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
        if DatabaseAccessor.sharedInstance.avatarExists() {
            performSegue(withIdentifier: "toMapView", sender: self)
        } else {
            // Remind players to create an avatar first.
            let alert = UIAlertController(title: "Warning", message: "You should create a new avatar first!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    // MARK: Segues
    @IBAction func unwindToStart(unwindSegue: UIStoryboardSegue) {
        
    }
    
    
}
