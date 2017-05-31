import UIKit

class MapViewController: UIViewController {
    
    // MARK: Views
    @IBOutlet var scenarioButtons: Array<UIButton>!
    
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
            if let destinationVC = segue.destination as? ScenarioViewController {
                if let senderButton = sender as? UIButton {
                    
                    // Check which scenario is chosen
                    var targetScenario = 0
                    while senderButton != scenarioButtons[targetScenario] {
                        targetScenario += 1
                    }
                    
                    // Offset the scnarioID by 1 (since scenarioID starts with 1)
                    destinationVC.scenarioID = targetScenario + 1
                    
                } else {
                    print("Error selecting scenario")
                }
            }
        }
    }
    
    @IBAction func unwindToMap(unwindSegue: UIStoryboardSegue) {
        
    }
}
