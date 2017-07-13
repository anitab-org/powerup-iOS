import UIKit

class MapViewController: UIViewController {
    
    // The background images for scenarios.
    let backgroundImages: [String?] = [
        nil,
        "class_room_background",
        nil,
        nil,
        nil,
        "class_room_background",
        "hospital_background",
        "library_background"
    ]
    
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
                
                let scenarioID = senderButton.tag
                
                // The scenario ID is stored in the tag of the button.
                destinationVC.scenarioID = scenarioID
                
                // Set the background image.
                destinationVC.backgroundImage = UIImage(named: backgroundImages[scenarioID] ?? "")
                
            } else {
                print("Error selecting sceanrio.")
            }
        }
    }
    
    @IBAction func unwindToMap(unwindSegue: UIStoryboardSegue) {
        
    }
}
