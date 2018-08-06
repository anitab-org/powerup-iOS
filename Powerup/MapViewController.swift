import UIKit

class MapViewController: UIViewController, SegueHandler {
    
    enum SegueIdentifier: String {
        case toScenarioView = "toScenarioView"
        case toCompletedView = "toCompletedView"
        case toShopView = "toShopView"
        case unwindToStartView = "unwindToStartView"
    }
    
    // The background images for scenarios.
    let backgroundImages: [String?] = [
        nil,
        "class_room_background",
        nil,
        nil,
        nil,
        "home_background",
        "hospital_background",
        "library_background"
    ]
    
    
    // MARK: Properties
    var dataSource: DataSource = DatabaseAccessor.sharedInstance
    var selectedScenarioName = ""
    
    // MARK: Views
    @IBOutlet var scenarioButtons: Array<UIButton>!
    @IBOutlet var scenarioImages: Array<UIImageView>!
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        unlockScenarios()
    }
    
    func unlockScenarios() {
        
        // Check which scenarios are unlocked.
        for (index, button) in scenarioButtons.enumerated() {
            let scenarioID = button.tag
            
            // Query database, see if the scenario is unlocked.
            var currScenario: Scenario
            do {
                currScenario = try dataSource.getScenario(of: scenarioID)
            } catch _ {
                let alert = UIAlertController(title: warningTitleMessage, message: errorLoadingScenarioMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: okText, style: .default))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            if !currScenario.unlocked {
                // Lock the building.
                button.isHidden = true
                scenarioImages[index].isHidden = true
            } else {
                // Unlock the building.
                button.isHidden = false
                scenarioImages[index].isHidden = false
            }
        }
    }
    
    // MARK: Actions
    @IBAction func scenarioSelected(_ sender: UIButton) {
        // Get the scenario.
        var selectedScenario: Scenario
        do {
            selectedScenario = try dataSource.getScenario(of: sender.tag)
        } catch _ {
            let alert = UIAlertController(title: warningTitleMessage, message: errorLoadingScenarioMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: okText, style: .default))
            self.present(alert, animated: true, completion: nil)

            return
        }
        
        // Configure the selected scenario name.
        selectedScenarioName = selectedScenario.name
        // If completed, go to completed view.
        if selectedScenario.completed {
            performSegueWithIdentifier(.toCompletedView, sender: sender)
        } else {
            // Go to the corresponding scenario
            performSegueWithIdentifier(.toScenarioView, sender: sender)
        }
    }
    
    
    // MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let senderButton = sender as? UIButton {
            let scenarioID = senderButton.tag
            switch segueIdentifierForSegue(segue){
            case .toScenarioView?:
                (segue.destination as? ScenarioViewController)?.scenarioID = scenarioID
                (segue.destination as? ScenarioViewController)?.scenarioName = selectedScenarioName
                (segue.destination as? ScenarioViewController)?.backgroundImage = UIImage(named: backgroundImages[scenarioID] ?? "")
                
            case .toCompletedView?:
                (segue.destination as? CompletedViewController)?.scenarioID = scenarioID
                (segue.destination as? CompletedViewController)?.scenarioName = selectedScenarioName
                (segue.destination as? CompletedViewController)?.backgroundImage = UIImage(named: backgroundImages[scenarioID] ?? "")
            case .toShopView?:
                 break
            case .unwindToStartView?:
                 break
            case .none:
                assertionFailure("Did not recognize segue identifier \(segue.identifier!)")
            }
            
            
        }
    }
    
    @IBAction func unwindToMap(unwindSegue: UIStoryboardSegue) {
        unlockScenarios()
    }
}
