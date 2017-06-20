import UIKit

class MapViewController: UIViewController {
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Actions
    @IBAction func scenarioSelected(_ sender: UIButton) {
        // Go to the corresponding scenario
        performSegue(withIdentifier: "toScenarioView", sender: sender)
    }
    
    // MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toScenarioView" {
            if let senderButton = sender as? UIButton, let destinationVC = segue.destination as? ScenarioViewController {
                
                // The scenario ID is stored in the tag of the button.
                destinationVC.scenarioID = senderButton.tag
                
                
            } else {
                print("Error selecting sceanrio.")
            }
        }
    }
    
    @IBAction func unwindToMap(unwindSegue: UIStoryboardSegue) {
        
    }
}
