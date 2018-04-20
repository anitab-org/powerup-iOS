import UIKit

class ResultsViewController: UIViewController {

    // TODO: Should determine how many Karma points will be given after each completion of scenario.
    var karmaGain = 20

    // MARK: Properties
    // This will be set in the ScenarioViewController.
    var completedScenarioID: Int = -1
    var completedScenarioName: String = ""
    var dataSource: DataSource = DatabaseAccessor.sharedInstance
    // Mark: Constants
     let scenarioHome = "Home"
    // MARK: Views
    @IBOutlet weak var karmaPointsLabel: UILabel!
    @IBOutlet weak var scenarioName: UILabel!

    @IBOutlet weak var continueButton: UIButton!
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
            let alert = UIAlertController(title: warningTitleMessage, message: errorLoadingKarmaPoints, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: okText, style: .default))
            self.present(alert, animated: true, completion: nil)

            return
        }

        // No Karma gain if the scenario is completed.
        do {

            if !(try dataSource.getScenario(of: completedScenarioID)).completed {

                // Notify the players of the karma gain with a pop-up.
                let notification = UIAlertController(title: hoorayTitleMesssage, message: "You gained \(karmaGain) Karma points!", preferredStyle: .alert)
                notification.addAction(UIAlertAction(title: okText, style: .default, handler: { action in self.gainKarmaPoints() }))
                self.present(notification, animated: true, completion: nil)
            }

        } catch _ {
            let alert = UIAlertController(title: warningTitleMessage, message: errorFetchingScenarioMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: okText, style: .default))
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
            let alert = UIAlertController(title: warningTitleMessage, message: errorSavingKarmaPointsMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: okText, style: .default))
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
            if nextScenario.name == scenarioHome {
                continueButton.isHidden = false
            }

            // Save the updated (next) scenario back to database.
            try dataSource.saveScenario(nextScenario)

        } catch _ {
            let alert = UIAlertController(title: warningTitleMessage, message: errorSavingScenarioCompletionMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: okText, style: .default))
            self.present(alert, animated: true, completion: nil)

            return
        }
    }

}
