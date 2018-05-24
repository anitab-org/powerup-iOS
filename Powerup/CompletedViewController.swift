import UIKit

class CompletedViewController: UIViewController,SegueHandler {
    enum SegueIdentifier: String {
        case toScenarioView = "toScenarioView"
        case unwindToMapView = "unwindtoMapView"
        case unwindToStartView = "unwindtoStartView"
    }
    
    
    // MARK: Properties
    // The scenario information of the view, set by MapViewController.
    var scenarioID: Int = -1
    var scenarioName: String = ""
    
    // The background image of the view, set by MapViewController.
    var backgroundImage: UIImage? = nil
    
    var dataSource: DataSource = DatabaseAccessor.sharedInstance
    
    // MARK: Views
    @IBOutlet weak var karmaPointsLabel: UILabel!
    @IBOutlet weak var scenarioLabel: UILabel!
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure scenario name.
        scenarioLabel.text = "Current Scenario: " + scenarioName
        
        // Configure score.
        do {
            let score = try dataSource.getScore()
            karmaPointsLabel.text = String(score.karmaPoints)
        } catch _ {
            // If the saving failed, show an alert dialogue.
            let alert = UIAlertController(title: warningTitleMessage, message: errorLoadingKarmaPoints, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: okText, style: .default))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
    }
    
    // MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue){
        case .toScenarioView?:
            (segue.destination as? ScenarioViewController)?.scenarioID = scenarioID
            (segue.destination as? ScenarioViewController)?.scenarioName = scenarioName
            (segue.destination as? ScenarioViewController)?.backgroundImage = backgroundImage
        case .unwindToMapView?:
            break
        case .unwindToStartView?:
            break
        case .none:
            assertionFailure("Did not recognize segue identifier \(segue.identifier!)")
      }
        
    }
    
}
