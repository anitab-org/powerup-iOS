import UIKit

class ResultsViewController: UIViewController {
    
    // TODO: Should determine how many Karma points will be given after each completion of scenario.
    var karmaGain = 20
    
    // MARK: Properties
    // This will be set in the ScenarioViewController.
    var completedScenarioID: Int = -1
    var completedScenarioName: String = ""

    var dataSource: DataSource = DatabaseAccessor.sharedInstance
    
    // MARK: Views
    @IBOutlet weak var karmaPointsLabel: UILabel!
    @IBOutlet weak var scenarioName: UILabel!
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure scenario name.
        scenarioName.text = "Current Scenario: " + completedScenarioName
        
        // Configure score.
        do {
            let score = try dataSource.getScore()
            karmaPointsLabel.text = String(score.karmaPoints)
        } catch _ {
            // If the saving failed, show an alert dialogue.
            let alert = UIAlertController(title: "Warning", message: "Error loading Karma points.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // No Karma gain if the scenario is completed.
        do {
            
            if !(try dataSource.getScenario(of: completedScenarioID)).completed {
                
                // Notify the players of the karma gain with a pop-up.
                let notification = UIAlertController(title: "Hooray!", message: "You gained \(karmaGain) Karma points!", preferredStyle: .alert)
                notification.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in self.gainKarmaPoints()}))
                self.present(notification, animated: true, completion: nil)
            }
            
        } catch _ {
            let alert = UIAlertController(title: "Warning", message: "Error fetching scenario data from database. Please retry this action. If that doesn't help, try restarting or reinstalling the app.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        saveScenarioAndUnlockNextScenario()
    }
    

    func gainKarmaPoints() {
        // Save the karma gains in database.
        let newScore: Score!
        do {
            newScore = try dataSource.getScore() + Score(karmaPoints: karmaGain)
            try dataSource.saveScore(score: newScore)
        } catch _ {
            // If the saving failed, show an alert dialogue.
            let alert = UIAlertController(title: "Warning", message: "Error saving Karma points.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // Update karma points label.
        karmaPointsLabel.text = String(newScore.karmaPoints)
    }
    
    func saveScenarioAndUnlockNextScenario() {
        do {
            // Get the current scenario.
            var currScenario = try dataSource.getScenario(of: completedScenarioID)
            
            currScenario.completed = true
            
            // Save the updated scenario back to database.
            try dataSource.saveScenario(currScenario)
            
            // Get the next scenario.
            var nextScenario = try dataSource.getScenario(of: currScenario.nextScenarioID)

            nextScenario.unlocked = true
            
            // Save the updated (next) scenario back to database.
            try dataSource.saveScenario(nextScenario)
            
        } catch _ {
            let alert = UIAlertController(title: "Warning", message: "Error saving scenario completion.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
    }
}
