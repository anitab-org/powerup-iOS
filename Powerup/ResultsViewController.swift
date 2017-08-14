import UIKit

class ResultsViewController: UIViewController {
    
    // TODO: Should detemine how many Karma points will be given after each completion of scenario.
    let karmaGain = 20
    
    // MARK: Views
    @IBOutlet weak var karmaPointsLabel: UILabel!
    
    // MARK: Properties
    var dataSource: DataSource = DatabaseAccessor.sharedInstance
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        gainKarmaPoints()
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
}
